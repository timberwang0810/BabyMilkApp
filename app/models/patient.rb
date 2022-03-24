require "rqrcode"
require "openssl"
require 'net/http'

class Patient < ApplicationRecord
    include AppHelpers::Activeable::InstanceMethods
    extend AppHelpers::Activeable::ClassMethods

    # TODO: Store this as env var
    @@cipher_key = "peepoo" * 4
    # Relationships
    has_many :visits
    has_many :bottles 

    # Scopes
    scope :alphabetical, -> { order('last_name, first_name') }
    
    # Validations
    validates_presence_of :patient_mrn, :first_name, :last_name, :dob
    validates_uniqueness_of :patient_mrn
    validates_date :dob, :on_or_before => lambda { Date.current }

    before_save :encode_mrn 
    after_save :generate_qr
    # Methods
    def name
        "#{last_name}, #{first_name}"
    end
    
    def proper_name
        "#{first_name} #{last_name}"
    end

    def get_age
        (((Date.today-self.dob).to_i)/365.25).to_i
    end

    def get_mrn
        decrypt(@@cipher_key, self.patient_mrn)
    end

    private
    def encrypt(key, str)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
        cipher.key = key
        s = cipher.update(str) + cipher.final
        s.unpack('H*')[0].upcase
    end

    def decrypt(key, str)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
        cipher.key = key
        cipher.padding = 0
        s = [str].pack("H*").unpack("C*").pack("c*")
        cipher.update(s) + cipher.final
    end

    def encode_mrn
        self.patient_mrn = encrypt(@@cipher_key, self.patient_mrn)
    end

    def generate_qr
        # qr = RQRCode::QRCode.new(self.patient_mrn)
        # png = qr.as_png(
        #     bit_depth: 1,
        #     border_modules: 4,
        #     color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        #     color: "black",
        #     file: nil,
        #     fill: "white",
        #     module_px_size: 6,
        #     resize_exactly_to: false,
        #     resize_gte_to: false,
        #     size: 120
        # )
        # puts qr
        # puts "\n------\n"
        # png.save("./app/assets/images/qr/#{self.patient_mrn}.png")


        label = Zebra::Zpl::Label.new(
            width:        900,
            length:       600,
            print_speed:  3
        )

        qrcode = Zebra::Zpl::Qrcode.new(
            data:             self.patient_mrn ,
            position:         [300,50],
            scale_factor:     10,
            correction_level: 'H'
        )
        label << qrcode
        print_job = Zebra::PrintJob.new 'Zebra_Technologies_ZTC_GX420d'
        print_job.print label, 'localhost'
        # puts qrcode.to_zpl
        # uri = URI 'http://api.labelary.com/v1/printers/12dpmm/labels/3x2/0'
        # http = Net::HTTP.new uri.host, uri.port
        # request = Net::HTTP::Post.new uri.request_uri
        # request.body = "^xa" + qrcode.to_zpl + "^xz"
        # response = http.request request

        # case response
        # when Net::HTTPSuccess then
        #     File.open "./app/assets/images/qr/#{self.patient_mrn}.png", 'wb' do |f| # change file name for PNG images
        #         f.write response.body
        #     end
        # else
        #     puts "Error: #{response.body}"
        # end
        rendered_zpl = Labelary::Label.render zpl: "^xa" + qrcode.to_zpl + "^xz"
        File.open "./app/assets/images/qr/#{self.patient_mrn}.png", 'wb' do |f| # change file name for PNG images
            f.write rendered_zpl
        end
    end

end
