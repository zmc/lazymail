require 'gtk2'

class LMGtkIcon < Gtk::StatusIcon
    attr_writer :unread
    def initialize
        super
        load_images
        @unread = 0
    end

    def load_images
        # the images are the same except for their palette.
        head = "iVBORw0KGgoAAAANSUhEUgAAABAAAAALBAMAAACEzBAKAAAAFVBMVE"  # base64
        active = "XaODjp\nWlrygYH5p6f/trb/4uL////pJer3"
        inactive = "VpaWmF\nhYWjo6PAwMDMzMzr6+v///8TRSyi"
        tail = "AAAAUUlEQVQI1x3GwQnAIBBE0TVYgFhB\nFoINGO+SgA0IFi" +
               "A6/ZeQ2fzLfyJHZqewBiy7eqBGYoa2XCKgvkYYnuAuw741\n" +
               "voPoY6ZdiALWiWHYRP6TD9jWEEbv7ex0AAAAAElFTkSuQmCC"
        active = head + active + tail
        inactive = head + inactive + tail

        loader = Gdk::PixbufLoader.new 'png'
        loader.last_write active.unpack('m')[0]
        @active = loader.pixbuf

        loader = Gdk::PixbufLoader.new 'png'
        loader.last_write inactive.unpack('m')[0]
        @inactive = loader.pixbuf
    end

    def notify(body)
        if body.length == 0
            set_pixbuf @inactive
            set_toolip "no unread messages"
        else
            set_pixbuf @active
            set_tooltip body
        end
    end

    def unread=(count)
        return if count < 0
        if count == 0
            set_tooltip "no unread messages"
            set_pixbuf @inactive
        elsif count == 1
            set_tooltip "1 unread message"
            set_pixbuf @active
        else
            set_tooltip "#{count} unread messages"
            set_pixbuf @active
        end
    end
end

