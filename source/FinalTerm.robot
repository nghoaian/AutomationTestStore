*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            https://automationteststore.com/
${BROWSER}        Chrome
${user}           an66528
${password}       test123
${invalidusername}    an123
${invalidpassword}    an123
${registeruser}    hoaian1
${registerpassword}    test123
${registeremail}    hoaian1@gmail.com

*** Test Cases ***
OpenBrower
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${URl}
    Title Should Be    A place to practice your automation skills!

Register
    Click Element    //*[@id="customer_menu_top"]/li/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/login
    Page Should Contain Element    //*[@id="maincontainer"]/div/div/div/div/div[1]/h2    #check form to register is appear
    ${temp}=    Get Text    //*[@id="maincontainer"]/div/div/div/div/div[1]/h2
    Log    ${temp}
    Comment    Should Be Equal As Strings    //*[@id="maincontainer"]/div/div/div/div/div[1]/h2    I am a new customer.
    Page Should Contain Element    //*[@id="accountFrm"]/fieldset/button    #check button visible to register
    Click Element    //*[@id="accountFrm"]/fieldset/button    #move to register page
    ${createpage_url}=    Get Location
    Should Be Equal As Strings    ${createpage_url}    https://automationteststore.com/index.php?rt=account/create    #check moved to create account page?
    Input Text    //*[@id="AccountFrm_firstname"]    An    #firstname
    Input Text    //*[@id="AccountFrm_lastname"]    Nguyen    #lastname
    Input Text    //*[@id="AccountFrm_email"]    ${registeremail}    #email
    Input Text    //*[@id="AccountFrm_address_1"]    Ton Duc Thang University    #address 1
    Input Text    //*[@id="AccountFrm_city"]    Ho Chi Minh    #city
    Click Element    //*[@id="AccountFrm_country_id"]
    Select From List By Value    //*[@id="AccountFrm_country_id"]    230    #choose country
    Input Text    //*[@id="AccountFrm_postcode"]    123
    Click Element    //*[@id="AccountFrm_zone_id"]
    Sleep    1s
    Select From List By Value    //*[@id="AccountFrm_zone_id"]    3780    #choose region
    Input Text    //*[@id="AccountFrm_loginname"]    ${registeruser}    #fill login name
    Input Text    //*[@id="AccountFrm_password"]    ${registerpassword}    #fill password
    Input Text    //*[@id="AccountFrm_confirm"]    ${registerpassword}    #fill password confirm
    Click Element    //*[@id="AccountFrm"]/div[4]/fieldset/div/div/label[2]
    Click Element    //*[@id="AccountFrm_agree"]
    Click Element    //*[@id="AccountFrm"]/div[5]/div/div/button    #click continue button to create account
    Sleep    2s
    ${current_url}=    Get Location
    ${alert}=    Run Keyword And Return Status    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/success    #check register fail or moved to register success page
    Log    ${alert}
    Run Keyword If    '${alert}' == 'False'    Exe Register With Error
    ...    ELSE IF    '${alert}' == 'True'    Exe Register Successful

Login
    Comment    Login With Valid Credential
    Click Element    //*[@id="customer_menu_top"]/li/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/login
    Input Text    id=loginFrm_loginname    ${registeruser}
    Input Text    id=loginFrm_password    ${registerpassword}
    Sleep    1s
    Click Button    //*[@id="loginFrm"]/fieldset/button
    #check if error appear
    Sleep    2s
    ${current_url}=    Get Location
    ${element_present}    Run Keyword And Return Status    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/account    #check alert 'login fail' appear when login?
    Run Keyword If    '${element_present}' == 'False'    Exe Login With Error
    ...    ELSE IF    '${element_present}' == 'True'    Exe Login Without Error

Search
    Click Element    //*[@id="categorymenu"]/nav/ul/li[1]/a    #click home button after login successful
    Page Should Contain Element    //*[@id="filter_keyword"]
    Input Text    //*[@id="filter_keyword"]    Dove Men +Care Body Wash    #keyword to search
    Sleep    1s
    Click Element    //*[@id="search_form"]/div/div    #click find button
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=product/search&keyword=Dove%20Men%20%2BCare%20Body%20Wash&category_id=0    #check moved to search page
    ${element_present}    Run Keyword And Return Status    Page Should Contain Element    //*[@id="maincontainer"]/div/div/div/div/div[3]/div[4]/div[1]/div/a    #check product is found?
    Run Keyword If    '${element_present}' == 'True'    Exe Search Successful
    ...    ELSE IF    '${element_present}' == 'False'    Exe Search Unsuccessful

ProductDetail
    Click Element    //*[@id="maincontainer"]/div/div/div/div/div[3]/div[4]/div[1]/div/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=product/product&keyword=Dove%20Men%20+Care%20Body%20Wash&category_id=0&product_id=75
    Wait Until Page Contains Element    //*[@id="product_details"]/div/div[2]/div/div/h1/span
    ${productname}    Get text    //*[@id="product_details"]/div/div[2]/div/div/h1/span    #get product name
    ${color}    Execute JavaScript    return document.defaultView.getComputedStyle(document.querySelector('h1.productname'), null).color    #get product name color
    ${price}    Get Text    //*[@id="product_details"]/div/div[2]/div/div/div[1]/div/div    #get product price
    Run Keyword If    '${productname}' == 'Dove Men +Care Body Wash' and '${color}' == 'rgb(0, 161, 203)' and '${price}' == '$6.70'    #check name, name color, price of product
    ...    Log    Product details are correct
    ...    ELSE IF    '${productname}' == 'Dove Men +Care Body Wash' and '${color}' == 'rgb(0, 161, 203)' and '${price}' == '£5.32'
    ...    Log    Product details are correct
    ...    ELSE IF    '${productname}' == 'Dove Men +Care Body Wash' and '${color}' == 'rgb(0, 161, 203)' and '${price}' == '6.29€'
    ...    Log    Product details are correct
    ...    ELSE    Log    Product details are incorrect

ChangeCurrency
    Page Should Contain Element    xpath=//a[@class="dropdown-toggle"]
    Mouse Over    xpath=//a[@class="dropdown-toggle"]
    Click Element    xpath=//a[contains(@href, 'currency=EUR')]
    Wait Until Page Contains Element    //*[@id="product_details"]/div/div[2]/div/div/h1/span    #check productname is appear?
    ${productname}    Get text    //*[@id="product_details"]/div/div[2]/div/div/h1/span    #get product name
    ${color}    Execute JavaScript    return document.defaultView.getComputedStyle(document.querySelector('h1.productname'), null).color    #get product name color
    ${price}    Get Text    //*[@id="product_details"]/div/div[2]/div/div/div[1]/div/div    #get product price
    Run Keyword If    '${productname}' == 'Dove Men +Care Body Wash' and '${color}' == 'rgb(0, 161, 203)' and '${price}' == '6.29€'    #check name, name color, price of product
    ...    Log    Product details by Euro Currency are correct
    ...    ELSE    Log    Product details by Euro Currency are incorrect
    Mouse Over    xpath=//a[@class="dropdown-toggle"]
    Click Element    xpath=//a[contains(@href, 'currency=GBP')]
    Wait Until Page Contains Element    //*[@id="product_details"]/div/div[2]/div/div/h1/span
    ${productname}    Get text    //*[@id="product_details"]/div/div[2]/div/div/h1/span    #get product name
    ${color}    Execute JavaScript    return document.defaultView.getComputedStyle(document.querySelector('h1.productname'), null).color    #get product name color
    ${price}    Get Text    //*[@id="product_details"]/div/div[2]/div/div/div[1]/div/div    #get product price
    Run Keyword If    '${productname}' == 'Dove Men +Care Body Wash' and '${color}' == 'rgb(0, 161, 203)' and '${price}' == '£5.32'    #check name, name color, price of product
    ...    Log    Product details by Pound Sterling Currency are correct
    ...    ELSE    Log    Product details by Pound Sterling Currency are incorrect

CheckQuantity
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
    Wait Until Page Contains Element    //*[@id="description"]/ul/li[1]    #check quantity is appear?
    ${quantity}    Get Text    //*[@id="description"]/ul/li[1]    #get quantity value
    Log    ${quantity}
    ${contain}=    Run Keyword And Return Status    Should Contain    ${quantity}    Out of Stock
    Run Keyword If    '${contain}' == 'False'
    ...    Log    Product Is In Stock
    ...    ELSE    Log    Product Is Out Of Stock
    # Login by an66528 / test123
    # Open Browser    https://automationteststore.com/index.php?rt=account/login    firefox
    # Input Text    id=loginFrm_loginname    an66528
    # Input Text    id=loginFrm_password    test123
    # Sleep    1s
    # Execute JavaScript    window.scrollBy(0, 300);
    # Sleep    2s
    # Click Button    //*[@id="loginFrm"]/fieldset/button

BuyProduct
        #Check Empty Cart
    Go To    https://automationteststore.com/
    Location Should Be    https://automationteststore.com/
        #change to $
    Mouse Over    xpath=//a[@class="dropdown-toggle"]
    Click Element    xpath=//a[contains(@href, 'currency=USD')]
    Sleep    2s
    ${cart_badge}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[1]
    Run keyword If    '${cart_badge}' == '0'    Log    Số lượng sản phẩm trong giỏ hàng đã đúng
    ...    ELSE    Log    Số lượng sản phẩm trong giỏ hàng không đúng
    ${cart_total}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[2]
    Run keyword If    '${cart_total}' == '$0.00'    Log    tổng tiền trong giỏ hàng đã đúng
    ...    ELSE    Log    tổng tiền trong giỏ hàng không đúng
        #find product
    Click Element    //*[@id="categorymenu"]/nav/ul/li[1]/a    #click home button after login successful
    Page Should Contain Element    //*[@id="filter_keyword"]
    Input Text    //*[@id="filter_keyword"]    Dove Men +Care Body Wash    #keyword to search
    Sleep    2s
    Click Element    //*[@id="search_form"]/div/div    #click find button
    Sleep    2s
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=product/search&keyword=Dove%20Men%20%2BCare%20Body%20Wash&category_id=0    #check moved to search page
    ${element_present}    Run Keyword And Return Status    Page Should Contain Element    //*[@id="maincontainer"]/div/div/div/div/div[3]/div[4]/div[1]/div/a    #check product is found?
        #check product detail to by the same product
    Click Element    //*[@id="maincontainer"]/div/div/div/div/div[3]/div[4]/div[1]/div/a
    Sleep    2s
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=product/product&keyword=Dove%20Men%20+Care%20Body%20Wash&category_id=0&product_id=75
    Wait Until Page Contains Element    //*[@id="product_details"]/div/div[2]/div/div/h1/span
    ${productname}    Get text    //*[@id="product_details"]/div/div[2]/div/div/h1/span    #get product name
    ${color}    Execute JavaScript    return document.defaultView.getComputedStyle(document.querySelector('h1.productname'), null).color    #get product name color
    ${price}    Get Text    //*[@id="product_details"]/div/div[2]/div/div/div[1]/div/div    #get product price
    Run Keyword If    '${productname}' == 'Dove Men +Care Body Wash' and '${color}' == 'rgb(0, 161, 203)' and '${price}' == '$6.70'    #check name, name color, price of product
    ...    Log    Product details are correct
    ...    ELSE    Log    Product details are incorrect
        #add to cart
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
    Scroll Element Into View    css=.cart
    Click Element    css=.cart
    Sleep    2s
        #Check Cart_badge=1
    ${cart_badge}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[1]
    Run keyword If    '${cart_badge}' == '1'    Log    Số lượng sản phẩm trong giỏ hàng đã đúng
    ...    ELSE    Log    Số lượng sản phẩm trong giỏ hàng không đúng
    ${cart_total}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[2]
    Run keyword If    '${cart_total}' == '$6.70'    Log    tổng tiền trong giỏ hàng đã đúng
    ...    ELSE    Log    tổng tiền trong giỏ hàng không đúng
        #Check total cart_1
    Execute JavaScript    window.scrollBy(0, 600);
    Sleep    2s
    ${total_lamout}=    Get Text    //*[@id="totals_table"]/tbody/tr[3]/td[2]/span
    Run keyword If    '${total_lamout}' == '$8.70'    Log    Tổng tiền đã đúng
    ...    ELSE    Log    Tổng tiền đã sai
        #Check out
    Click Element    //*[@id="cart_checkout1"]
    Sleep    2s
        # Comment    Close All Browsers

BuySameTypeProduct
    Comment    Execute JavaScript    window.scrollBy(600, 0);
    Comment    Sleep    2s
    Comment    Click Element    /html/body/div/header/div[1]/div/div[2]/div/div[3]/div/ul/li[3]/a/span
    Go To    https://automationteststore.com/index.php?rt=checkout/cart
    Sleep    2s
    Click Element    //*[@id="cart_quantity75"]
    Sleep    2s
    Clear Element Text    //*[@id="cart_quantity75"]
    Sleep    2s
    Input Text    //*[@id="cart_quantity75"]    2
    Sleep    2s
    Click Element    //*[@id="cart_update"]
    Sleep    2s
        #Check cart_badge=2
    ${cart_badge}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[1]
    Run keyword If    '${cart_badge}' == '2'    Log    Số lượng sản phẩm trong giỏ hàng đã đúng
    ...    ELSE    Log    Số lượng sản phẩm trong giỏ hàng không đúng
    ${cart_total}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[2]
    Run keyword If    '${cart_total}' == '$13.40'    Log    tổng tiền trong giỏ hàng đã đúng
    ...    ELSE    Log    tổng tiền trong giỏ hàng không đúng
        #Check total cart_2
    Execute JavaScript    window.scrollBy(0, 600);
    Sleep    2s
    ${total_lamout}=    Get Text    //*[@id="totals_table"]/tbody/tr[3]/td[2]/span
    Run keyword If    '${total_lamout}' == '$15.40'    Log    Tổng tiền đã đúng
    ...    ELSE    Log    Tổng tiền đã sai
        #Check out
    Click Element    //*[@id="cart_checkout1"]
    Sleep    2s

BuyDifTypeProduct
    Comment    Click Element    /html/body/div/div[1]/div[1]/section/nav/ul/li[1]/a
    Comment    Sleep    2s
    Comment    Mouse Over    xpath=//*[@id="categorymenu"]/nav/ul/li[3]/a
    Comment    Click Element    xpath=//*[@id="categorymenu"]/nav/ul/li[3]/div/ul[1]/li[1]/a
    Comment    Sleep    2s
    Click Element    //*[@id="categorymenu"]/nav/ul/li[1]/a    #click home button after login successful
    Page Should Contain Element    //*[@id="filter_keyword"]
    Input Text    //*[@id="filter_keyword"]    Tropiques Minerale Loose Bronzer    #keyword to search
    Sleep    1s
    Click Element    //*[@id="search_form"]/div/div    #click find button
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
        #add to cart
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
    Scroll Element Into View    css=.cart
    Click Element    css=.cart
    Sleep    2s
        #So sánh 2 Model
    ${model_1}=    Get Text    xpath=/html/body/div/div[2]/div/div/div/form/div/div[1]/table/tbody/tr[2]/td[3]
    ${model_2}=    Get Text    xpath=/html/body/div/div[2]/div/div/div/form/div/div[1]/table/tbody/tr[3]/td[3]
    Run keyword If    '${model_1}'=='${model_2}'    Log    Sản phẩm cùng loại
    ...    ELSE    Log    Sản phẩm khác loại
        #Check cart_badge=3
    ${cart_badge}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[1]
    Run keyword If    '${cart_badge}' == '3'    Log    Số lượng sản phẩm trong giỏ hàng đã đúng
    ...    ELSE    Log    Số lượng sản phẩm trong giỏ hàng không đúng
    ${cart_total}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[2]
    Run keyword If    '${cart_total}' == '$51.90'    Log    tổng tiền trong giỏ hàng đã đúng
    ...    ELSE    Log    tổng tiền trong giỏ hàng không đúng
        #Check total cart_3
    Execute JavaScript    window.scrollBy(0, 600);
    Sleep    2s
    ${total_lamout}=    Get Text    //*[@id="totals_table"]/tbody/tr[3]/td[2]/span
    Run keyword If    '${total_lamout}' == '$53.90'    Log    Tổng tiền đã đúng
    ...    ELSE    Log    Tổng tiền đã sai

UpdateCart
        #numberOfProduct
    Execute JavaScript    window.scrollBy(0, 0);
    Sleep    2s
    Click Element    //*[@id="cart_quantity53b1a0e11451071a263d5a530074cc3395"]
    Sleep    2s
    Clear Element Text    //*[@id="cart_quantity53b1a0e11451071a263d5a530074cc3395"]
    Sleep    2s
    Input Text    //*[@id="cart_quantity53b1a0e11451071a263d5a530074cc3395"]    3
    Sleep    2s
    Click Element    //*[@id="cart_update"]
    Sleep    4s
    Comment    UpdateCart_removeProduct
    Comment    Click Element    /html/body/div/div[2]/div/div/div/form/div/div[1]/table/tbody/tr[2]/td[7]/a/i
    Comment    Sleep    2s
    Comment    Comment    Click Element    //*[@id="cart_update"]
    Comment    Comment    Sleep    4s
        #Check cart_badge=5
    ${cart_badge}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[1]
    Run keyword If    '${cart_badge}' == '5'    Log    Số lượng sản phẩm trong giỏ hàng đã đúng
    ...    ELSE    Log    Số lượng sản phẩm trong giỏ hàng không đúng
    ${cart_total}=    Get Text    xpath=/html/body/div/header/div[2]/div/div[3]/ul/li/a/span[2]
    Run keyword If    '${cart_total}' == '$128.90'    Log    tổng tiền trong giỏ hàng đã đúng
    ...    ELSE    Log    tổng tiền trong giỏ hàng không đúng
        #Checkout + Check total cart_4
    Execute JavaScript    window.scrollBy(0, 600);
    Sleep    2s
    ${total_lamout}=    Get Text    //*[@id="totals_table"]/tbody/tr[3]/td[2]/span
    Run keyword If    '${total_lamout}' == '$130.90'    Log    Tổng tiền đã đúng
    ...    ELSE    Log    Tổng tiền đã sai
    Click Element    //*[@id="cart_checkout2"]

CheckDetailCheckout
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
            #username of Shipping
    ${username of Shipping}=    Get Text    xpath=//td[@class='align_left'][1]
    Run keyword If    '${username of Shipping}' == 'An Nguyen'    Log    Đúng Username
    ...    ELSE    Log    Sai Username
            #username of Payment
    ${username of Payment}=    Get Text    xpath=//table[@class='table confirm_payment_options']//td[@class='align_left'][1]
    Run keyword If    '${username of Payment}' == 'An Nguyen'    Log    Đúng Username
    # Comment    ...
    ...    ELSE    Log    Sai Username
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
    ${cart_badge1}=    Get Text    xpath=//tr[td/a[contains(@href, 'product_id=75')]]
            #2 sp
    Run keyword If    '${cart_badge1}' == '2'    Log    Đúng số lượng sản phẩm
    ...    ELSE    Log    Sai số lượng sản phẩm
    ${cart_badge2}=    Get Text    xpath=//tr[td/a[contains(@href, 'product_id=53')]]/td[4]
            #3 sp
    Run keyword If    '${cart_badge2}' == '3'    Log    Đúng số lượng sản phẩm
    ...    ELSE    Log    Sai số lượng sản phẩm
    Execute JavaScript    window.scrollBy(0, 500);
    Sleep    2s
            #Total = 130.90
    ${cart_block_total}=    Get Text    xpath=//span[@class='bold totalamout']
    Run keyword If    '${cart_block_total}' == '$130.90'    Log    Tổng tiền đã đúng
    ...    ELSE    Log    Tổng tiền đã sai
        #Confirm Order
    Click Element    //*[@id="checkout_btn"]
    Sleep    2s
    Location Should Be    https://automationteststore.com/index.php?rt=checkout/success
    ${noti success}=    Get Text    //*[@id="maincontainer"]/div/div/div/h1/span[1]
    Run keyword If    '${noti success}' == 'Your Order Has Been Processed!'    Log    Mua hàng thành công
    ...    ELSE    Log    Mua hàng không thành công

LinkToSocialNetwork
    ${current_window}=    Get Location    #https://automationteststore.com/
    Comment    ${main_window}=    Get Window Handles
    Wait Until Element Is Visible    //a[@href='http://www.facebook.com' and @title='Facebook']\n
    Click Element    //a[@href='http://www.facebook.com' and @title='Facebook']\n
    Sleep    2s
    Switch Window    new
    Location Should Be    https://www.facebook.com/
    Sleep    1s
    Wait Until Element Is Visible    //*[@id="email"]
    Wait Until Element Is Visible    //*[@id="pass"]
    Input Text    //*[@id="email"]    0932923013
    Input Text    //*[@id="pass"]    hoaian98247
    Comment    Wait Until Element Is Visible    //*[@id="u_0_b_3F"]
    Comment    ${button_text}=    Get Text    //button[@data-testid='royal_login_button']
    Comment    Should Be Equal    ${button_text}    Log in
    Close Window
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Click Element    //*[@id="customer_menu_top"]/li/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/login
    Input Text    id=loginFrm_loginname    ${registeruser}
    Input Text    id=loginFrm_password    ${registerpassword}
    Sleep    1s
    Click Button    //*[@id="loginFrm"]/fieldset/button
    Comment    Switch Window    ${current_window}
    Sleep    5s

Logout
    Mouse Over    //*[@id="customer_menu_top"]/li/a/div
    Click Element    //*[@id="customer_menu_top"]/li/ul/li[10]
    ${logoutpage_url}    Get Text    //*[@id="maincontainer"]/div/div/div/h1/span[1]
    Should Be Equal As Strings    ${logoutpage_url}    ACCOUNT LOGOUT
    Location Should Be    https://automationteststore.com/index.php?rt=account/logout
    Click Element    //*[@id="maincontainer"]/div/div/div/div/section/a    #click continue button to logout
    Sleep    2s
    ${home_url}    Get Location
    Should Be Equal As Strings    ${home_url}    https://automationteststore.com/
    Sleep    2s

LoginWithInvalidCredential
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${URl}
    Title Should Be    A place to practice your automation skills!
    Comment    Login With Invalid Credential
    Click Element    //*[@id="customer_menu_top"]/li/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/login
    Input Text    id=loginFrm_loginname    ${invalidusername}
    Input Text    id=loginFrm_password    ${invalidpassword}
    Click Button    //*[@id="loginFrm"]/fieldset/button
    Sleep    1s
    #check if error appear
    Sleep    2s
    ${current_url}=    Get Location
    ${element_present}    Run Keyword And Return Status    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/account    #check alert 'login fail' appear when login?
    Run Keyword If    '${element_present}' == 'False'    Exe Login With Error
    ...    ELSE IF    '${element_present}' == 'True'    Exe Login Without Error

CheckQuantityOutOfStock
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${URl}
    Title Should Be    A place to practice your automation skills!
    Comment    Login With Invalid Credential
    Click Element    //*[@id="customer_menu_top"]/li/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/login
    Input Text    id=loginFrm_loginname    ${user}
    Input Text    id=loginFrm_password    ${password}
    Click Button    //*[@id="loginFrm"]/fieldset/button
    Sleep    1s
    #check if error appear
    Sleep    2s
    ${current_url}=    Get Location
    ${element_present}    Run Keyword And Return Status    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/account    #check alert 'login fail' appear when login?
    Run Keyword If    '${element_present}' == 'False'    Exe Login With Error
    ...    ELSE IF    '${element_present}' == 'True'    Exe Login Without Error
    Click Element    //*[@id="categorymenu"]/nav/ul/li[1]/a    #click home button after login successful
    Page Should Contain Element    //*[@id="filter_keyword"]
    Input Text    //*[@id="filter_keyword"]    Dove Men +Care Body Wash    #keyword to search
    Sleep    1s
    Click Element    //*[@id="search_form"]/div/div    #click find button
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=product/search&keyword=Dove%20Men%20%2BCare%20Body%20Wash&category_id=0    #check moved to search page
    ${element_present}    Run Keyword And Return Status    Page Should Contain Element    //*[@id="maincontainer"]/div/div/div/div/div[3]/div[2]/div[1]/div/a    #check product is found?
    Run Keyword If    '${element_present}' == 'True'    Exe Search Successful
    ...    ELSE IF    '${element_present}' == 'False'    Exe Search Unsuccessful
    Click Element    //*[@id="maincontainer"]/div/div/div/div/div[3]/div[2]/div[1]/div/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=product/product&keyword=Dove%20Men%20+Care%20Body%20Wash&category_id=0&product_id=77
    Execute JavaScript    window.scrollBy(0, 300);
    Sleep    2s
    ${quantity}    Get Text    //*[@id="description"]/ul/li[1]    #get quantity value
    Log    ${quantity}
    ${contain}=    Run Keyword And Return Status    Should Contain    ${quantity}    Out of Stock
    Run Keyword If    '${contain}' == 'False'
    ...    Log    Product Is In Stock
    ...    ELSE    Log    Product Is Out Of Stock

RegisterFail
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${URl}
    Title Should Be    A place to practice your automation skills!
    Click Element    //*[@id="customer_menu_top"]/li/a
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/login
    Page Should Contain Element    //*[@id="maincontainer"]/div/div/div/div/div[1]/h2    #check form to register is appear
    ${temp}=    Get Text    //*[@id="maincontainer"]/div/div/div/div/div[1]/h2
    Log    ${temp}
    Comment    Should Be Equal As Strings    //*[@id="maincontainer"]/div/div/div/div/div[1]/h2    I am a new customer.
    Page Should Contain Element    //*[@id="accountFrm"]/fieldset/button    #check button visible to register
    Click Element    //*[@id="accountFrm"]/fieldset/button    #move to register page
    ${createpage_url}=    Get Location
    Should Be Equal As Strings    ${createpage_url}    https://automationteststore.com/index.php?rt=account/create    #check moved to create account page?
    Input Text    //*[@id="AccountFrm_firstname"]    An    #firstname
    Input Text    //*[@id="AccountFrm_lastname"]    Nguyen    #lastname
    Input Text    //*[@id="AccountFrm_email"]    an66528@gmail.com    #email
    Input Text    //*[@id="AccountFrm_address_1"]    Ton Duc Thang University    #address 1
    Input Text    //*[@id="AccountFrm_city"]    Ho Chi Minh    #city
    Click Element    //*[@id="AccountFrm_country_id"]
    Select From List By Value    //*[@id="AccountFrm_country_id"]    230    #choose country
    Input Text    //*[@id="AccountFrm_postcode"]    123
    Click Element    //*[@id="AccountFrm_zone_id"]
    Sleep    1s
    Select From List By Value    //*[@id="AccountFrm_zone_id"]    3780    #choose region
    Input Text    //*[@id="AccountFrm_loginname"]    an66528    #fill login name
    Input Text    //*[@id="AccountFrm_password"]    ${registerpassword}    #fill password
    Input Text    //*[@id="AccountFrm_confirm"]    ${registerpassword}    #fill password confirm
    Click Element    //*[@id="AccountFrm"]/div[4]/fieldset/div/div/label[2]
    Click Element    //*[@id="AccountFrm_agree"]
    Click Element    //*[@id="AccountFrm"]/div[5]/div/div/button    #click continue button to create account
    Sleep    2s
    ${current_url}=    Get Location
    ${alert}=    Run Keyword And Return Status    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/success    #check register fail or moved to register success page
    Log    ${alert}
    Run Keyword If    '${alert}' == 'False'    Exe Register With Error
    ...    ELSE IF    '${alert}' == 'True'    Exe Register Successful




*** Keywords ***
Exe Login Without Error
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/account
    Log    Login Successful
    Sleep    2s

Exe Login With Error
    Wait Until Element Is Visible    css=.alert.alert-error.alert-danger
    ${error_message}=    Get Text    css=.alert.alert-error.alert-danger
    Log    ${error_message}
    Capture Page Screenshot
    Log    Login Fail
    Sleep    2s
    Close Browser

Exe Search Successful
    Log    Search Successful
    Sleep    2s

Exe Search Unsuccessful
    Log    Search Unsuccessful
    Sleep    2s

Check Quantity
    Page Should Contain    Out of Stock

Exe Register With Error
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/create
    Wait Until Element Is Visible    css=.alert.alert-error.alert-danger
    ${error_message}=    Get Text    css=.alert.alert-error.alert-danger
    Log    ${error_message}
    Capture Page Screenshot
    Log    Fail To Create An Account
    Sleep    2s

Exe Register Successful
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    https://automationteststore.com/index.php?rt=account/success
    Log    Create An Account Successful
    Sleep    2s
    ${actual_text}    Get Text    //*[@id="maincontainer"]/div/div[1]/div/h1/span[1]
    Should Be Equal As Strings    ${actual_text}    YOUR ACCOUNT HAS BEEN CREATED!
    Click Element    //*[@id="maincontainer"]/div/div[1]/div/div/section/a    #move to main page aftter create account successful
    Click Element    //*[@id="categorymenu"]/nav/ul/li[1]/a    #click home button
    Mouse Over    //*[@id="customer_menu_top"]/li/a/div
    Click Element    //*[@id="customer_menu_top"]/li/ul/li[10]    #click logout of dropdownbox
    ${logoutpage}    Get Text    //*[@id="maincontainer"]/div/div/div/h1/span[1]
    Should Be Equal As Strings    ${logoutpage}    ACCOUNT LOGOUT
    Click Element    //*[@id="maincontainer"]/div/div/div/div/section/a    #click continue button to logout
    ${home_url}    Get Location
    Should Be Equal As Strings    ${home_url}    https://automationteststore.com/
    Sleep    2s
