module Capybara
  class Session
    def has_image?(src)
      has_xpath?("//img[contains(@src, '#{src}')]")
    end

    def has_submit_button?(value)
      has_xpath?("//input[contains(@type, 'submit') and contains(@value, '#{value}')]")
    end
  end
end