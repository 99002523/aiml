##########################################################
#script name : play a video
#description : play a video
#created by : Auto generated
#created date : 2021-04-16 18:07:00
#reviced by : 
#copy rights : LTTS
#########################################################

***Settings***
Documentation    play a video

#importing Libraries
Resource    ../lib/robot/keywords-coordinates.robot
Library    SeleniumLibrary    screenshot_root_directory=screenshot
Library    OperatingSystem


***Test Cases***
play a video
    [Setup]    Test Setup

    Launch App    https://spuul.com/login

    ${status}     Login    https://spuul.com/login    tautomation40012@gmail.com    Psnumber#40012
    Run Keyword If     "${status}"=="True"     Log To Console     Login successful
    ...    ELSE     Fail     Login failed

    ${status}     Verify Homepage
    Run Keyword If     "${status}"=="True"     Log To Console     Verify Homepage successful
    ...    ELSE     Fail     Verify Homepage failed

    ${status}     Search By Title    apr
    Run Keyword If     "${status}"=="True"     Log To Console     Search By Title successful
    ...    ELSE     Fail     Search By Title failed

    ${status}     Play Video
    Run Keyword If     "${status}"=="True"     Log To Console     Play Video successful
    ...    ELSE     Fail     Play Video failed

    ${status}     Verify Play
    Run Keyword If     "${status}"=="True"     Log To Console     Verify Play successful
    ...    ELSE     Fail     Verify Play failed

    [Teardown]    Run Keyword If Test Failed    Test Fail Teardown
