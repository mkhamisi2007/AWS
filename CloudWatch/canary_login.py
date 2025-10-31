# zip -r canary-login.zip canary_login.py 
# upload in S3
from aws_synthetics.selenium import synthetics_webdriver as syn_webdriver
from aws_synthetics.common import synthetics_logger as logger
import time

def main():
    # ایجاد مرورگر Headless (Chrome)
    driver = syn_webdriver.Chrome()
    try:
        # مرحله 1: باز کردن صفحه لاگین
        url = "https://example.com/login"
        driver.get(url)
        logger.info(f"Opened URL: {url}")
        time.sleep(2)

        # مرحله 2: پر کردن فرم لاگین
        username_box = driver.find_element_by_name("username")
        password_box = driver.find_element_by_name("password")
        login_button = driver.find_element_by_xpath("//button[@type='submit']")

        username_box.send_keys("test_user")
        password_box.send_keys("TestPassword123")
        login_button.click()
        logger.info("Login form submitted")

        time.sleep(3)

        # مرحله 3: بررسی موفقیت ورود
        if "dashboard" in driver.current_url.lower():
            logger.info("✅ Login successful - dashboard loaded")
        else:
            raise Exception("❌ Login failed or dashboard not loaded")

    finally:
        driver.quit()

def handler(event=None, context=None):
    main()
