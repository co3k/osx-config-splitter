require 'fileutils'
require 'plist'
require './lib/BaseParser.rb'

module ConfigSplitter
  class Preferences < BaseParser
    FILENAME_BASE = 'preferences'

    def acceptable?(filepath1, filepath2)
      [filepath1, filepath2].select { |filepath|
        File.basename(filepath).start_with?(FILENAME_BASE)
      }.count() == 2
    end

    def split(plist1, plist2)
      def write(plist, dirname)
        dirpath = './dist/%s' % [dirname]

        FileUtils.mkdir_p(dirpath)

        plist['NetworkServices'].each {|k, v|
          userDefinedName = v['UserDefinedName']
          filename = '%s_NetworkServices_%s.plist' % [FILENAME_BASE, userDefinedName]
          File.write(dirpath + '/' + filename, v.to_plist);
        }
        plist.delete 'NetworkServices'

        File.write(dirpath + '/' + FILENAME_BASE + '.plist', plist.to_plist);
      end

      write(plist1, 'a')
      write(plist2, 'b')
    end
  end
end
