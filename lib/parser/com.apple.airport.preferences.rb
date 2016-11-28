require 'fileutils'
require 'plist'
require './lib/BaseParser.rb'

module ConfigSplitter
  class ComAppleAirportPreferences < BaseParser
    FILENAME_BASE = 'com.apple.airport.preferences'

    def acceptable?(filepath1, filepath2)
      [filepath1, filepath2].select { |filepath|
        File.basename(filepath).start_with?(FILENAME_BASE)
      }.count() == 2
    end

    def split(plist1, plist2)
      def write(plist, dirname)
        dirpath = './dist/%s' % [dirname]

        FileUtils.mkdir_p(dirpath)

        plist['KnownNetworks'].each {|k, v|
          ssid = v['SSIDString']
          filename = '%s_KnownNetworks_%s.plist' % [FILENAME_BASE, ssid]
          File.write(dirpath + '/' + filename, v.to_plist);
        }
        plist.delete 'KnownNetworks'

        File.write(dirpath + '/' + FILENAME_BASE + '.plist', plist.to_plist);
      end

      write(plist1, 'a')
      write(plist2, 'b')
    end
  end
end
