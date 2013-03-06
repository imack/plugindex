require 'open-uri'

class FetchPluginInfo
  @queue = :codex

  def self.perform(plugin_id)

    plugin = Plugin.find( plugin_id )

    begin
      rawdoc = open("http://wordpress.org/extend/plugins/#{plugin.name}")
      doc = Nokogiri::HTML(rawdoc)
    rescue OpenURI::HTTPError => ex
      puts ex
      if ex == "404 Not Found"
        plugin.dead = true
        plugin.save
      end
      return
    end

    download_count = nil
    last_update = nil

    doc.css('meta').each do |meta|
      if meta['itemprop'] == "interactionCount"
        content = meta['content']
        if content.split(":")[0] == "UserDownloads"
          download_count = content.split(":")[1].to_i
          puts download_count
        end
      elsif meta['itemprop'] == "dateModified"
        content = meta['content']
        last_update = DateTime.strptime(content, '%Y-%m-%d')
        puts last_update
      end
    end

    plugin.last_update = last_update
    plugin.total_downloads = download_count
    plugin.readings.create( :downloads => download_count )
    plugin.save

  end
end