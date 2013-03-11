require 'open-uri'

PLUGINS_INDEX = "http://plugins.svn.wordpress.org"

namespace "codex" do

  desc "Grab the plugins index and enqueue fetch jobs"
  task :update => :environment do
    doc = Nokogiri::HTML(open( PLUGINS_INDEX ) )

    doc.css('a').each do |meta|
      name =  meta['href']
      name.slice!(-1)

      plugin = Plugin.find_or_create_by(name: name)

      if plugin.dead || ( !plugin.last_update.nil? && plugin.last_update < 2.years.ago )
        puts "skipping #{plugin.name}"
      else
        puts "grabbing #{plugin.name}"
        Resque.enqueue( FetchPluginInfo, plugin.id)
      end

    end
  end
end
