##########################################################
#script name : login to application
#description : login to application
#created by : Auto generated
#created date : 2021-04-16 18:07:00
#reviced by : 
#copy rights : LTTS
#########################################################

***Settings***
Documentation    login to application

#importing Libraries
Resource    ../lib/robot/keywords-coordinates.robot
Library    SeleniumLibrary    screenshot_root_directory=screenshot
Library    OperatingSystem


***Test Cases***
login to application
    [Setup]    Test Setup

    Launch App    https://spuul.com/login

    ${status}     Login    https://spuul.com/login    tautomation40012@gmail.com    Psnumber#40012
    Run Keyword If     "${status}"=="True"     Log To Console     Login successful
    ...    ELSE     Fail     Login failed

    ${status}     Verify Homepage
    Run Keyword If     "${status}"=="True"     Log To Console     Verify Homepage successful
    ...    ELSE     Fail     Verify Homepage failed

    [Teardown]    Run Keyword If Test Failed    Test Fail Teardown
