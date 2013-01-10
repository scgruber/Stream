class Streams < Shoes
  url '/',        :index
  url '/w/(\w+)', :entry
  url '/all',     :all

  DROPS = Hash.new

  def index
    stack do
      title "Just start writing..."
      para "Press enter to add to the stream"
      @box = edit_line :width => "100%"
      keypress do |k|
        if k == "\n"
          textlist = @box.text.split(' ')
          key = textlist[0]
          DROPS.store(key, textlist.drop(1))
          visit "/w/#{key}"
        end
      end
      para link("View all entries", :click => "/all")
    end
  end

  def entry(str)
    t = DROPS.fetch(str, [])
    stack do
      title str
      @box = edit_line :width => "100%"
      keypress do |k|
        if k == "\n"
          textlist = @box.text.split(' ')
          key = textlist[0]
          DROPS.store(key, textlist.drop(1))
          visit "/w/#{key}"
        end
      end
      flow do
        para strong "#{str} :: "
        t.each do |w|
          if DROPS.fetch(w, []) == []
            para w
          else
            para link(w, :click => "/w/#{w}")
          end
        end
      end
      para link("View all entries", :click => "/all")
    end
  end

  def all
    stack do
      title "The whole stream:"
      DROPS.each do |k, d|
        flow :width => "100%" do
          subtitle k
          flow do
            d.each do |w|
              if DROPS.fetch(w, []) == []
                para w
              else
                para link(w, :click => "/w/#{w}")
              end
            end
          end
        end
      end
      para link("return to main", :click => "/")
    end
  end
end

Streams

Shoes.app :title => "Streams of Consciousness"
