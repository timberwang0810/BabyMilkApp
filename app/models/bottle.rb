require "openssl"
require 'net/http'
class Bottle < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  @@cipher_key = ENV["CIPHER_KEY"]
  attr_accessor :qr_image

  belongs_to :patient
  #belongs_to :checkin_nurse_id
  #belongs_to :checkout_nurse_id

  validates_presence_of :collected_date, :storage_location
  #validates_datetime :administration_date, on_or_after: :collected_date
  #add validations for different types of expiration dates
  #validates_datetime :expiration_date, after: :collected_date 

  validates :storage_location, inclusion: { in: %w(fridge freezer), 
    message: "%{value} is not a valid storage location" }


  scope :by_patient, -> { joins(:patient).order('patients.last_name, patients.first_name')}
  scope :for_patient, ->(patient) { where(patient_id: patient.id) }

  scope :by_collection, -> { order('collected_date')}
  scope :by_administration, -> { order('administration_date')}
  scope :by_expiration, -> { order('expiration_date')}

  #callbacks
  #before_save
  before_save :set_bottle_details
  after_save :generate_qr
  after_destroy :make_bottle_inactive

  def get_qr_image
    "/assets/qr/#{encrypt(@@cipher_key, self.id.to_s)}.png"
  end
  #fix this
  protected
  def set_bottle_details
    if self.storage_location == 'fridge'
      self.expiration_date = self.collected_date + 14
    elsif self.storage_location =='freezer'
      self.expiration_date = self.collected_date + 182.5
    else
      self.errors.add(:bottle, "invalid storage location")
    end
  end

  def make_bottle_inactive
    self.administration_date = Date.today
    self.make_inactive
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

    def print_zpl_str(name, label)
        zpl = ''
        label.dump_contents zpl
        puts "\n#{name}:\n#{zpl}\n\n"
        zpl
    end
    def generate_qr
        encrypted = encrypt(@@cipher_key, self.id.to_s)
        label = Zebra::Zpl::Label.new(
            width:        900,
            length:       600,
            print_speed:  3
        )
        qrcode = Zebra::Zpl::Qrcode.new(
            data:             encrypted,
            position:         [200,100],
            scale_factor:     6,
            correction_level: 'H'
        )
        name_text = Zebra::Zpl::Text.new(
            data: self.patient.name,
            position: [400,120],
            font_size: 30,
            print_mode: "N"
        )
        storage_text = Zebra::Zpl::Text.new(
            data: "Store: #{self.storage_location}",
            position: [400,170],
            font_size: 30,
            print_mode: "N"
        )
        date_text = Zebra::Zpl::Text.new(
            data: "Expire: #{self.expiration_date}",
            position: [400,220],
            font_size: 30,
            print_mode: "N"
        )
        label << qrcode
        label << name_text
        label << storage_text
        label << date_text
        rendered_zpl = Labelary::Label.render zpl: print_zpl_str('raw_zpl', label)
        File.open "./app/assets/images/qr/#{encrypted}.png", 'wb' do |f| # change file name for PNG images
            f.write rendered_zpl
        end
        # print_job = Zebra::PrintJob.new 'Zebra_Technologies_ZTC_GX420d'
        # print_job.print label, 'localhost'
    end


end
