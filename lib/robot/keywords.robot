*** Settings ***
Documentation    This is the robot file where keywords are defined.

#selenium and os library
Library    SeleniumLibrary    screenshot_root_directory=screenshot        
Library    OperatingSystem
Library    ../python/xpath.py
Library    ../python/ObjectDetection.py
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
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${LOGIN_PROFILE_ICON}[1]    ${None}
    Run Keyword If    "${is_none}"=="True"    Page Should Contain Element    ${LOGIN_PROFILE_ICON}[1]
    Run Keyword If    "${is_none}"=="True"    Click Element    ${LOGIN_PROFILE_ICON}[1]  
	[Return]	${is_none}
    
Select Signin Icon
    #Detector
    @{LOGIN_ICON}    xpath    signinbutton
	${is_none}    Run Keyword And Return Status    Should Not Be Equal    ${LOGIN_ICON}[1]    ${None}
    Run Keyword If    "${is_none}"=="True"    Page Should Contain Element    ${LOGIN_ICON}[1]
    Run Keyword If    "${is_none}"=="True"    Click Element    ${LOGIN_ICON}[1]     
	[Return]	${is_none}	
                
#keyword to verify whether login page is visible. 
Verify Loginpage   
    #Detector
    @{SIGN_IN}    xpath    usernametextbox
    ${status}    Run Keyword And Return Status    Page Should Contain Element    ${SIGN_IN}[1] 
    [Return]    ${status}
    
#keyword input text and password and click on login/signin
Login   
	${profile_status}    Select Profile    profileicon2
	${signin_icon_status}    Select Signin Icon
	${login_page_visibility}    Verify Loginpage
	#Detector
	@{USERNAME_ID}    xpath    usernametextbox
	@{PASSWORD}    xpath    passwordtextbox
	@{SIGN_IN}    xpath    loginbutton
	Run Keyword If    "${login_page_visibility}" == "True"    Page Should Contain Element    ${USERNAME_ID}[1]
    Run Keyword If    "${login_page_visibility}" == "True"    Input Text    ${USERNAME_ID}[1]    ${uname}
    ${pass}    Run Keyword And Return Status    Page Should Contain Element    ${PASSWORD}[1]
    Log To Console    ${pass} 
    sleep    2s	
    Run Keyword If    "${pass}" == "False"    Press Keys    None    ENTER     
    Input Password    ${PASSWORD}[1]    ${pname}
    Log To Console    ${SIGN_IN}[0]
    Click Coordinates    ${SIGN_IN}[0]
	#Wait Until Element Is Enabled    ${SIGN_IN}[1] 
    #Click Element    ${SIGN_IN}[1]    
	Select Profile    profileicon1
	${status}    Verify Homepage
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PROFILE_ICON}
	
    [Return]    ${status} 

#keyword to verify whether home page is visible
Verify Homepage
    #Detector
    @{PROFILE_ICON}    xpath    profileicon
	#Detector
	@{SIGN_OUT}    xpath    logoutbutton
	${profile_button}    Run Keyword And Return Status    Should Not Be Equal    ${PROFILE_ICON}[1]    ${None}
	${sign_out_button}    Run Keyword And Return Status    Should Not Be Equal    ${SIGN_OUT}[1]    ${None}
	${status}    Set Variable If    "${profile_button}"=="True"    ${profile_button}    ${sign_out_button}
	[Return]    ${status}
    #${profile_button}    Run Keyword And Return Status    Page Should Contain Element    ${PROFILE_ICON}[1]
	#${sign_out_button}    Run Keyword And Return Status    Page Should Contain Element    ${SIGN_OUT}[1]
	#${status}    Set Variable If    "${profile_button}"=="True"    ${profile_button}    ${sign_out_button}
    #[Return]    ${status}

#keyword to hover over profile icon 
Go To Profile
    #Detector
    @{PROFILE_ICON}    xpath    profileicon
	#Detector
	@{SIGN_OUT}    xpath    logoutbutton
    ${signoutvalue}    Run Keyword And Return Status    Page Should Contain Element    ${PROFILE_ICON}[1]                
    Run Keyword If    "${signoutvalue}"=="True"    Wait Until Element Is Visible    ${PROFILE_ICON}[1]    
    Run Keyword If    "${signoutvalue}"=="True"    Mouse Over    ${PROFILE_ICON}[1]
    ${status}    Run Keyword And Return Status    Page Should Contain Element    ${SIGN_OUT}[1]
	Run Keyword If    "${status}"=="False"    Click Element    ${PROFILE_ICON}[1]
    [Return]    ${status}
     
#keyword to logout from website  
Logout
    #Detector
	@{SIGN_OUT}    xpath    logoutbutton
    Wait Until Element Is Visible    ${SIGN_OUT}[1]   
	#Click Coordinates    ${SIGN_OUT}[0]
    #Scroll Element Into View    ${SIGN_OUT}[1]
    Click Element    ${SIGN_OUT}[1]  
	${status}    Run Keyword And Return Status    Page Should Contain Element    ${SIGN_IN}[1] 
    [Return]    ${status}  


#keyword calling object detection   
Detector
	sleep    5s
    Capture Page Screenshot    ${IMAGE_PATH}
	detect

#keyword calling object detection
Click Coordinates
    [Arguments]    ${value}
    @{coordinates}    Split String    ${value}    separator=,
	Log To Console    ${coordinates}[0]
	Log To Console    ${coordinates}[1]
    click    ${coordinates}[0]    ${coordinates}[1]