*** Settings ***
Documentation    This is the robot file where keywords are defined.

Library    SeleniumLibrary    screenshot_root_directory=screenshot        
Library    OperatingSystem
Library    ../python/xpath.py
Library    ../python/integrated.py
Library    ../python/clickcoordinates.py
Library    String

#importing resoource file including all variables
Resource    ../../variables/bigflix_variables.resource
    
*** Keywords ***
#keyword for setting up the environment variable and opening browser
Test Setup
    Append To Environment Variable    Path   ${EXECDIR}${/}driver${/}
    Open Browser    browser=${BROWSER}    
    Maximize Browser Window
    Set Browser Implicit Wait    10s

#keyword for closing browser on failure after capturing screenshot
Test Fail Teardown
    Capture Page Screenshot    ${FAILURE_IMAGE_PATH}   
	Close Browser
	
#keyword for closing browser
Test Teardown
    Close Browser

#keyword to open particular url
Launch App
	[Arguments]    ${URL}
    Go To    ${URL}
        
Select Profile
	[Arguments]    ${value}
    #Detector
	@{LOGIN_PROFILE_ICON}    xpath    ${value}
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${LOGIN_PROFILE_ICON}[0]    ${None}
	Run Keyword If    "${is_none}"=="True"    Click Coordinates    ${LOGIN_PROFILE_ICON}[0]  
	[Return]	${is_none}
    
Select Signin Icon
    #Detector
    @{LOGIN_ICON}    xpath    signinbutton
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${LOGIN_ICON}[0]    ${None}
	Run Keyword If    "${is_none}"=="True"    Click Coordinates    ${LOGIN_ICON}[0]    
	[Return]	${is_none}	
                
#keyword to verify whether login page is visible. 
Verify Loginpage   
    #Detector
    @{SIGN_IN}    xpath    usernametextbox
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_IN}[0]    ${None}
	#Run Keyword If    "${is_none}"=="True"    Click Coordinates    ${SIGN_IN}[0] 
    [Return]    ${is_none}
    
#keyword input text and password and click on login/signin
Login
    [Arguments]    ${URL}    ${uname}    ${pname}
	#Capture Page Screenshot    ${IMAGE_PATH}
	${profile_status}    Select Profile    profileicon
	${signin_icon_status}    Select Signin Icon
	${login_page_visibility}    Verify Loginpage
	Detector
	${value}    Html Source
	Extractor And Integrator    ${value}  
	@{USERNAME_ID}    xpath    usernametextbox
	@{PASSWORD}    xpath    passwordtextbox
	@{SIGN_IN}    xpath    loginbutton
	sleep    2s
	Run Keyword If    "${login_page_visibility}" == "True"    Page Should Contain Element    ${USERNAME_ID}[1]
    Run Keyword If    "${login_page_visibility}" == "True"    Input Text    ${USERNAME_ID}[1]    ${uname}
    ${pass}    Run Keyword And Return Status    Page Should Contain Element    ${PASSWORD}[1]
    sleep    2s
    Run Keyword If    "${pass}" == "False"    Press Keys    None    ENTER   
    Log To Console    ${pname}
    Input Password    ${PASSWORD}[1]    ${pname}
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_IN}[1]    ${None}
	sleep    5s
    #Run Keyword If    "${is_none}"=="True"    Click Element    ${SIGN_IN}[1]
	Log To Console    ${SIGN_IN}[0]
    Click Coordinates    ${SIGN_IN}[0]
	#Select Profile    profileicon
	sleep    5s
	${status}    Verify Homepage
    [Return]    ${status} 

#keyword to verify whether home page is visible
Verify Homepage
    Detector
    @{PROFILE_ICON}    xpath    profileicon
	Detector
	@{SIGN_OUT}    xpath    logoutbutton
	${value}    Html Source
	Extractor And Integrator    ${value}
	${profile_button}    Run Keyword And Return Status    Should Not Be Equal    ${PROFILE_ICON}[0]    ${None}
	${sign_out_button}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_OUT}[0]    ${None}
	${status}    Set Variable If    "${profile_button}"=="True"    ${profile_button}    ${sign_out_button}
	${visibility}    Set Variable If    "${profile_button}"=="True"    ${PROFILE_ICON}[0]    ${SIGN_OUT}[0]
	[Return]    ${status}


#keyword to search by title
Search By Title
    [Arguments]    ${value}
	Click Searchicon
    Enter Search Title    ${value}

#keyowrd to click search
Click Searchicon
    #Detector
	@{SEARCHICONVALUE}    xpath    searchicon
	@{SEARCHTEXTBOXVALUE}    xpath    searchtextbox
	${search_icon}    Run Keyword And Return Status    Should Not Be Equal    ${SEARCHICONVALUE}[1]    ${None} 
	${search_text_box}    Run Keyword And Return Status    Should Not Be Equal    ${SEARCHTEXTBOXVALUE}[1]    ${None}
	${visibility}=  Set Variable If  '${search_icon}' == 'True'    ${SEARCHICONVALUE}[1]    ${SEARCHTEXTBOXVALUE}[1]
	Log To Console    ${visibility}
	Run Keyword If    "${search_icon}"=="True"    Click Element    ${visibility}
	[Return]    ${search_icon}

#keyword to enter search text
Enter Search Title
	#Detector
    [Arguments]    ${value}
    @{SEARCHTEXTBOXVALUE}    xpath    searchtextbox
	${search_text_box}    Run Keyword And Return Status    Should Not Be Equal    ${SEARCHTEXTBOXVALUE}[1]    ${None}
	Run Keyword If    "${search_text_box}" == "True"    Input Text    ${SEARCHTEXTBOXVALUE}[1]    ${value}
	Run Keyword If    "${search_text_box}" == "True"    Press Keys    None    ENTER
	Page Should Contain Element    ${value}
	[Return]    ${search_text_box}
	
#keyword to play video
Play Video
	#Detector 
    @{PLAY_BUTTON}    xpath    playbutton
	${play_visibility}    Run Keyword And Return Status    Should Not Be Equal    ${PLAY_BUTTON}[1]    ${None} 
	Run Keyword If    "${play_visibility}"=="True"    Click Element    ${PLAY_BUTTON}[1]    ${value}
	[Return]    ${play_visibility}
	
#verify play
Verify Play
    #Detector
	@{PAUSE_BUTTON}    xpath    pausebutton
	${play_visibility}    Run Keyword And Return Status    Should Not Be Equal    ${PAUSE_BUTTON}[1]    ${None} 
	Run Keyword If    "${play_visibility}"=="True"    Click Element    ${PAUSE_BUTTON}[1]    ${value}
	[Return]    ${play_visibility}
    

#keyword to hover over profile icon 
Go To Profile
    #Detector
    @{PROFILE_ICON}    xpath    profileicon
	@{SIGN_OUT}    xpath    logoutbutton
	${profile_button}    Run Keyword And Return Status    Should Not Be Equal    ${PROFILE_ICON}[0]    ${None}
	${sign_out_button}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_OUT}[0]    ${None}
	${visibility}    Set Variable If    "${profile_button}"=="True"    ${PROFILE_ICON}[0]    ${SIGN_OUT}[0]
    ${apr}    Run Keyword And Return Status    Should Be Equal    ${PROFILE_ICON}[0]    ${visibility}
	#Run Keyword If    "${apr}" == "True"    Mouse Over    ${PROFILE_ICON}[1]
	#${status}    Run Keyword And Return Status    Page Should Contain Element    ${SIGN_OUT}[0]
	Run Keyword If    "${apr}" == "True"    Click Element    ${PROFILE_ICON}[0]
	#Run Keyword If    "${status}"=="False"    Click Element    ${PROFILE_ICON}[0]
    [Return]    ${apr}  
    
#keyword to logout from website  
Logout
    #Detector
	@{SIGN_OUT}    xpath    logoutbutton
	#Log To Console    ${value}
    ${sign_out_button}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_OUT}[0]    ${None}
	#Run Keyword If    "${sign_out_button}"=="True"    Click Element    ${SIGN_OUT}[1]
	Log To Console    ${SIGN_OUT}[0]
    Click Coordinates    ${SIGN_OUT}[0]
    [Return]    ${sign_out_button}  


#keyword calling object detection   
Detector
	sleep    5s
    Capture Page Screenshot    ${IMAGE_PATH}
	detect

Extractor And Integrator
    [Arguments]    ${value}
	${url}    Execute Javascript  return window.location.href
	Log To Console    ${url}
	${session_id}    Get Session Id
	Log To Console    ${session_id}
	Add Cookie    foo    bar
	${cookie}    Get Cookie    foo
	Log To Console    ${cookie}  
	${cookies_list}    Get Cookies
	Log To Console    ${cookie}
	session_creator    ${url}
    #xextract    ${url}    ${value}    ${session_id}   
	merger
	
#keyword calling object detection
Click Coordinates
    [Arguments]    ${value}
    @{coordinates}    Split String    ${value}    separator=,
	Log To Console    ${coordinates}[0]
	Log To Console    ${coordinates}[1]
    click    ${coordinates}[0]    ${coordinates}[1]
	
#keyword to get html source
Html Source
    ${value}    Execute JavaScript    return document.body.innerHTML
	[Return]    ${value}
	Create File    javascript.html     ${value}
	#${value}    Get Source
	#Create File   source.html    ${value}