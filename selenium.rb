require 'rubygems'
require 'selenium-webdriver'

# 先抓原始碼，可直接在編輯器上看
def fileinput (doc)
    File.open("source_code.html", "w+") do |file|
        file.write(doc)
    end
end

target = URI('https://www.gov.tw/taiwan/Default.aspx').normalize

# 使用chrome driver
browser = Selenium::WebDriver.for :chrome
browser.get target

fileinput browser.page_source


catagory = browser.find_elements(:class_name, "select-catagory")[1]

# 抓到的 select-catagory 會有兩個(兩個內容一模一樣，但只有第二個有辦法顯示出text，待研究)，取第二個
options = catagory.find_elements(:tag_name, "option")

# 找出 select-catagory 所有的option內容，並依次點擊，抓取細項內容
options.each do |option|
    # 網站透過 js 控制下拉選單，所以模擬點擊
    option.click

    # 抓到的 select-content 會有兩個(同 catagory)，取第二個
    content = browser.find_elements(:class_name, "select-content")[1]
    # 找出 select-content 所有的option內容
    content_options = content.find_elements(:tag_name, "option")
    content_options.each do |co|
        # 印出文字與網址
        puts co.text
        puts co.attribute("data-href");
    end
end

browser.quit