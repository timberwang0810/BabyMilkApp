# QR Code Pipeline in Ruby on Rails
## Connecting the Scanner

Connecting the scanner involves simply inserting its USB cable and giving permission to the scanner to act as a keyboard. For our scanner model (INSERT MODEL NAME HERE), the scanner needs to also scan a barcode in order to activate the QR scanning feature (by default it only works with barcodes). That barcode can be found here: https://cdn.cnetcontent.com/7c/0a/7c0ad393-193d-4948-964f-1891ad1ca578.pdf in the "QR code" section. 

## Connecting the Printer

The Zebra printer needs to connect to an outlet in addition to the computer via a USB cable. The installation of the printing driver is different depending on the computer OS:

**On Mac**: You can add the Zebra printer via "System Preferences" -> "Printers and Scanners" ->  "+ (add printer)". Select the Zebra printer and in the "Use" dropdown, select "Select Software" and type _Zebra_ into the Filter bar of the Printer Software pop-up and select the "ZPL" option from the list. You can then set any printer configurations at the link http://localhost:631/printers (such as label size and dpi (dots per inches)). For our configuration, we set the dpi to 300 and label size to be 3 x 2 inches. 

**On Windows** A thorough guide can be found here: https://picqer.com/en/support/articles/installing-zebra-printer

## Working with QR code in Ruby

For our app, we are using the "zebra-zpl" gem, which allows us to encode data into QR code and send straight to our printer. Installation and guide are found here: https://github.com/bbulpett/zebra-zpl. The gem can encode several data into ZPL code (which is the language interpreted by the Zebra printer), inject them into a single label object and send it to the printer queue to be printed.

We are also using the "labelary" gem to transform the generated ZPL code into a png file, found here: https://github.com/rjocoleman/labelary. The gem sends the ZPL code to the Labelary API endpoint, turning it into a raw image, which we then write to a png file id'ed by the ciphered patient MRN number. 



