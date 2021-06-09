*** Settings ***
Documentation    This is the robot file where keywords are defined.

Library    SeleniumLibrary    screenshot_root_directory=screenshot        
Library    OperatingSystem
Library    ../python/xpath.py
Library    ../python/integrated.py
Library    ../python/clickcoordinates.py
Library    ../python/regex.py
Library    String
    
*** Variables ***
${BROWSER}    chrome

${IMAGE_PATH}    ../screenshot/input.png

${FAILURE_IMAGE_PATH}    ../screenshot/failed.png

${JAVA_SCRIPT_PATH}    ../sourcecode/javascript.html


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
    ${status}    Run Keyword And Return Status    Go To    ${URL}
	[Return]	${status}
        
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
    @{USERNAME_TEXT}    xpath    usernametextbox
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${USERNAME_TEXT}[0]    ${None}
	#Run Keyword If    "${is_none}"=="True"    Click Coordinates    ${SIGN_IN}[0] 
    [Return]    ${is_none}
  
Enter Username
	[Arguments]    ${login_page_visibility}    ${uname}    @{USERNAME_ID}
	Log To Console    ${USERNAME_ID}[1]
	Log To Console    ${uname}
    Run Keyword If    "${login_page_visibility}" == "True"    Page Should Contain Element    ${USERNAME_ID}[1]
    Run Keyword If    "${login_page_visibility}" == "True"    Input Text    ${USERNAME_ID}[1]    ${uname}    

Enter Password
	[Arguments]    ${pname}    @{PASSWORD}
    ${pass}    Run Keyword And Return Status    Page Should Contain Element    ${PASSWORD}[1]
    sleep    2s
    Log To Console    ${PASSWORD}[1]	
    Run Keyword If    "${pass}" == "False"    Press Keys    None    ENTER   
    Log To Console    ${pname}
    Input Password    ${PASSWORD}[1]    ${pname}

  
Click Signin
	[Arguments]    @{SIGN_IN}
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_IN}[1]    ${None}
	sleep    5s
    Run Keyword If    "${is_none}"=="True"    Click Element    ${SIGN_IN}[1]
    #Click Coordinates    ${SIGN_IN}[0]
    

#keyword to verify whether home page is visible
Verify Homepage
    Detector
    @{PROFILE_ICON}    xpath    profileicon
	Detector
	@{SIGN_OUT}    xpath    logoutbutton
	Extractor And Integrator
	${profile_button}    Run Keyword And Return Status    Should Not Be Equal    ${PROFILE_ICON}[0]    ${None}
	${sign_out_button}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_OUT}[0]    ${None}
	${status}    Set Variable If    "${profile_button}"=="True"    ${profile_button}    ${sign_out_button}
	${visibility}    Set Variable If    "${profile_button}"=="True"    ${PROFILE_ICON}[0]    ${SIGN_OUT}[0]
	[Return]    ${status}


#keyword input text and password and click on login/signin
Login
    [Arguments]    ${uname}    ${pname}
	${profile_status}    Select Profile    profileicon
	${signin_icon_status}    Select Signin Icon
	${login_page_visibility}    Verify Loginpage
	Detector
	Extractor And Integrator
	@{USERNAME_ID}    xpath    usernametextbox
	@{PASSWORD}    xpath    passwordtextbox
	@{SIGN_IN}    xpath    loginbutton
	sleep    2s
	Enter Username    ${login_page_visibility}    ${uname}    @{USERNAME_ID}    
	Enter Password    ${pname}    @{PASSWORD}
	Click Signin    @{SIGN_IN}
	sleep    5s
	${status}    Verify Homepage
    [Return]    ${status} 

#keyowrd to click search
Click Searchicon
    Detector
	@{SEARCHICONVALUE}    xpath    searchicon
	@{SEARCHTEXTBOXVALUE}    xpath    searchtextbox
	${search_icon}    Run Keyword And Return Status    Should Not Be Equal    ${SEARCHICONVALUE}[1]    ${None} 
	${search_text_box}    Run Keyword And Return Status    Should Not Be Equal    ${SEARCHTEXTBOXVALUE}[1]    ${None}
	${visibility}    Set Variable If    '${search_icon}' == 'True'    ${SEARCHICONVALUE}[1]    ${SEARCHTEXTBOXVALUE}[1]
	Run Keyword If    "${search_icon}"=="True"    Click Element    ${visibility}
	[Return]    ${visibility}

#keyword to enter search text
Enter Search Title
	#Detector
    [Arguments]    ${value}
    @{SEARCHTEXTBOXVALUE}    xpath    searchtextbox
	@{RESULTS_FOUND}    xpath     resultsfound
	@{NO_RESULTS_FOUND}    xpath     noresultsfound
	${search_text_box}    Run Keyword And Return Status    Should Not Be Equal    ${SEARCHTEXTBOXVALUE}[1]    ${None}
	Run Keyword If    "${search_text_box}" == "True"    Input Text    ${SEARCHTEXTBOXVALUE}[1]    ${value} 
	Run Keyword If    "${search_text_box}" == "True"    Press Keys    None    ENTER
	sleep    5s
	${resultsfound_status}    Run Keyword And Return Status    Should Not Be Equal    ${RESULTS_FOUND}[1]    ${None}
	${noresultsfound_status}    Run Keyword And Return Status    Should Not Be Equal    ${NO_RESULTS_FOUND}[1]    ${None}
	${status}    Set Variable If    "${resultsfound_status}"=="True"    ${resultsfound_status}    ${noresultsfound_status}
	Run Keyword If     "${resultsfound_status}"=="True"     Log To Console     search resuls found
    ...    ELSE     Fail     search resuls not found
	[Return]    ${search_text_box}
	
#keyword to search by title
Search By Title
    [Arguments]    ${value}
	${status}    Click Searchicon
	Log To Console    ${status}
    Enter Search Title    ${value}
	
	
#keyword to play video
Play Video
	#Detector 
    @{RESULTS_FOUND}    xpath    resultsfound
	@{PLAY_BUTTON}    xpath    playbutton
	${play_visibility}    Run Keyword And Return Status    Should Not Be Equal    ${RESULTS_FOUND}[1]    ${None} 
	Run Keyword If    "${play_visibility}" == "True"    Page Should Contain Element    ${RESULTS_FOUND}[1]
	Run Keyword If    "${play_visibility}" == "True"    Mouse Over        ${RESULTS_FOUND}[1]
	Run Keyword If    "${play_visibility}"=="True"    Click Element    ${RESULTS_FOUND}[1]
	[Return]    ${play_visibility}
	
#verify play
Verify Play
	${BEFORE}    time_checker_before
	sleep    5s
	${AFTER}    time_checker_after
	${PLAY_STATUS}    video_playing    ${BEFORE}    ${AFTER}
	[Return]    ${PLAY_STATUS}
    

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
    [Arguments]
	${value}    Html Source
    xextract    ${value}  
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
	Create File    ${JAVA_SCRIPT_PATH}     ${value}
	[Return]    ${value}
	#${value}    Get Source
	#Create File   source.html    ${value}
