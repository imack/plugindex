require 'open-uri'
require 'PP'

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


  desc "Create a Stats object based on most recent codex readings"
  task :analyze => :environment do

    stats = Stats.new
    puts "==========New Plugins=========="
    Plugin.where(:created_at.gt => 6.days.ago, :total_downloads.gt => 0).order_by([:total_downloads, :desc]).limit(10).each do |plugin|
      puts "#{plugin.name}: #{plugin.total_downloads}"
      stats.newest << [plugin.id, plugin.display_name, plugin.name, plugin.total_downloads.to_s]
    end

    puts "==========Hot Plugins=========="
    Plugin.where({:updated_at.gt => 6.days.ago, :total_downloads.gt => 1000}).order_by([:percent_growth, :desc]).limit(10).each do |plugin|
      puts "#{plugin.name}: #{(plugin.percent_growth * 100).round(2)  }%"
      stats.hottest << [plugin.id, plugin.display_name, plugin.name, (plugin.percent_growth * 100).round(2).to_s]
    end

    puts "==========Most Downloaded Total=========="
    Plugin.where({:updated_at.gt => 6.days.ago, :total_downloads.ne => nil}).order_by([:total_downloads, :desc]).limit(10).each do |plugin|
      puts "#{plugin.name}: #{plugin.total_downloads}"
      stats.total << [plugin.id, plugin.display_name, plugin.name, plugin.total_downloads.to_s]
    end

    puts "==========Most Downloaded Weekly=========="
    Plugin.where({:updated_at.gt => 6.days.ago, :weekly_download.ne => nil}).order_by([:weekly_download, :desc]).limit(10).each do |plugin|
      puts "#{plugin.name}: #{plugin.weekly_download}"
      stats.top_weekly << [plugin.id, plugin.display_name, plugin.name, plugin.weekly_download.to_s]
    end

    PP.pp stats
    stats.save

  end

end
