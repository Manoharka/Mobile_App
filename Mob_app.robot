*** Settings ***
Library    AppiumLibrary   
Library    AutoItLibrary  
Library    String       
 




*** Test Cases ***
Test_001
    Open Application    http://localhost:4723/wd/hub    platformName=Android    deviceName=emulator-5554    appPackage=com.ken42.portal    appActivity=com.ken42.portal.MainActivity    automationName=UiAutomator2    newCommandTimeout=2500    
    Sleep    15    
    # Open Application    http://localhost:4723/wd/hub    platformName=Android    deviceName=emulator-5554    appPackage=com.google.android.apps.messaging    appActivity=com.google.android.apps.messaging.ui.conversationlist.ConversationListActivity - Messages    automationName=UiAutomator2    newCommandTimeout=2500
    Input Text    //android.widget.EditText[@text="Enter Name of the institute"]    demo
    Sleep    5  
    Click Element    //android.widget.TextView[@text="Demo School"]
    Sleep    5    
    Click Element    //android.widget.TextView[@text="Go"]
    Sleep    5
    Input Text    //android.widget.EditText[@text="Enter your Unique Id"]    amrut@sch.ken42.com
    Sleep    5    
    Click Element    //android.widget.TextView[@text="SIGN IN"]
    Sleep    10  
    Click Element    //android.widget.EditText[@text="Select a mobile number..."]
    Sleep    10    
    Click Element    //android.widget.CheckedTextView[@text="9930433566"]
    Sleep    10    
    Click Element    //android.widget.TextView[@text="GET OTP"]
    Sleep    5   
    ${message}=    Get Text    //android.widget.TextView[contains(@text,"OTP")]
    Sleep    5    
    ${message1}=    Fetch From Right    ${message}    is${SPACE}
    Sleep    5    
    Click Element    //android.widget.Button[@text="OK"]
    Sleep    5    
    Input Text    //android.widget.EditText[@text="Enter OTP"]    ${message1}
    Sleep    5    
    Click Element    //android.widget.TextView[@text="SUBMIT"]
    Sleep    20 
    # Click Element    //android.widget.ImageView
    # Sleep    5    
    # Element Text Should Be    //android.widget.ImageView[@text="FACULTY PORTAL"]   FACULTY PORTAL
    # Sleep    5    
    # Element Text Should Be    //android.widget.TextView[@text="Amrutanshu Mishra"]    Amrutanshu Mishra
    # Sleep    5    
    # Click Element    //android.widget.TextView[@text="Home"]
    # Sleep    10    
    Press Keycode    82
    Sleep    5        
    Click Element    //android.widget.TextView[@text="Start"]     
    Sleep    20
    Click Element    //android.widget.Button[@text="Allow"]
    Sleep    30    
    # Click Element    //android.widget.TextView[@text="."]     
    # Sleep    10    
    Press Keycode    4    
    sleep     10
     
    
          
