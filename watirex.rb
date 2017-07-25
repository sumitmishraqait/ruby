
require 'page-object'
require 'watir'

class Login
  include PageObject
  page_url('https://hris.qainfotech.com/login.php')
  link(:login_link,class:'active')
  text_field(:username, id: 'txtUserName')

    text_field(:password, name: 'txtPassword')
  button(:signin_button, name: 'Submit')
end

browser=Selenium::WebDriver.for :chrome, :driver_path => 'D:/chromedriver.exe'
browser.manage.timeouts.implicit_wait=10
login = Login.new(browser) ;
login.goto;
login.login_link;
login.username = 'sumitmishra';
login.password = 'Sumit@1806';
login.signin_button;
