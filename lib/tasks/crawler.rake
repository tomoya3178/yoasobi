namespace :crawler do
    task crawler: :environment do
        puts Info.first().to_yaml
        
        require 'anemone'
        require 'nokogiri'
        require 'kconv'
        
        urls = [
            'https://club-joule.com/category/event/',
            #'https://club-joule.com/category/event/?month=202003',
            'https://clubpiccadilly.jp/events/',
            'http://world-kyoto.com/schedule/',
        ]
            
        urls.each do |url|
            flyer_xpath = ''
            
            if (url === 'https://club-joule.com/category/event/')
                pattern = %r[2020\/.+]
                date_xpath = '//*[@id="loop_box"]/div[1]/div[1]'
                title_xpath = '//*[@id="loop_box"]/div[2]/div'
                flyer_xpath = '//*[@id="loop_box"]/div[4]/div[1]/div[3]/a/img'
                place_id = 1
            end
            
            if (url === 'https://clubpiccadilly.jp/events/')
                pattern = %r[day\_20.+|event\_20.+]
                date_xpath = '/html/body/section[3]/div/div/div/div[1]/div/p[1]/span'
                title_xpath = '/html/body/section[3]/div/div/div/div[1]/div/h1'
                place_id = 2
            end
            
            if (url === 'http://world-kyoto.com/schedule/')
                pattern = %r[2020\/.+]
                month_xpath = '/html/body/div/article/section/div[2]/div/p/span[3]'
                day_xpath = '/html/body/div/article/section/div[2]/div/p/span[1]'
                title_xpath = '/html/body/div/article/section/div[2]/div/div/h2'
                place_id = 3
            end
        
            opts = {
                :depth_limit => 1,
                #:storage => Anemone::Storage::SQLite3(),
            }
        
            Anemone.crawl(url, opts) do |anemone|
                #anemone.on_every_page do |page|
                anemone.on_pages_like(pattern) do |page|
                    doc = Nokogiri::HTML.parse(page.body.toutf8)
                    url = page.url.to_s
                    flyer = doc.xpath(flyer_xpath).attribute('src').value
                    title = doc.xpath(title_xpath).text
                    date = doc.xpath(date_xpath).text
                    
                    if (place_id === 3)
                        month = doc.xpath(month_xpath).text
                        day = doc.xpath(day_xpath).text
                        day = day + '日'
                        date = day + month
                    end
                    
                    date = date.to_date
                    
                    unless Info.exists?(url: url)
                        Info.create(
                            url: url,
                            flyer: flyer,
                            title: title,
                            date: date,
                            place_id: place_id
                        )
                    end
                end
            end
        end
    end
end
