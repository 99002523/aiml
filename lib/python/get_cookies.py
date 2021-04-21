import pathlib, pickle
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
import undetected_chromedriver as chromedriver

chromedriver.TARGET_VERSION = 90
chromedriver.install()


def save_cookies_file(url):
    chrome_driver_path = str(pathlib.Path(__file__).parent.absolute()) + '/chromedriver.exe'
    chrome_options = Options()
    chrome_options.add_experimental_option('debuggerAddress', '127.0.0.1:1997')
    driver = webdriver.Chrome(options = chrome_options, executable_path = chrome_driver_path)
    driver.get(url)
    pickle.dump(driver.get_cookies(), open("cookies.pkl", "wb"))



save_cookies_file("https://spuul.com/premium-plan")
