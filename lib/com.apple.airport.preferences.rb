require 'fileutils'
require 'plist'

def split(plist1, plist2)
    def write(plist, dirname)
        dirpath = './dist/%s' % [dirname]
        filename_base = 'com.apple.airport.preferences'

        FileUtils.mkdir_p(dirpath)

        plist['KnownNetworks'].each {|k, v|
            ssid = v['SSIDString']
            filename = '%s_KnownNetworks_%s.plist' % [filename_base, ssid]
            File.write(dirpath + '/' + filename, v.to_plist);
        }
        plist.delete 'KnownNetworks'

        File.write(dirpath + '/' + filename_base + '.plist', plist.to_plist);
    end

    write(plist1, 'a')
    write(plist2, 'b')
end
