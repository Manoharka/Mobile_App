*** Settings ***
Library    RequestsLibrary    
Library    Collections    
Library    OperatingSystem   
Library    String    
Library    JSONLibrary   
Library    ExcelLibrary    
  
*** Variables ***
${baseurl}=    https://rahulshettyacademy.com
${BaseUrl1}=    https://api-dev.ken42.com:8243
${BaseUrl2}=    https://api.ken42.com/school/stage/pfsportal
${App_baseurl}=    https://api.ken42.com/schoolstageapp
${token_url}=    https://school-stg-applicationportal.ken42.com/api/app
${Int_url}=    https://api.ken42.com/school/stage/pfs
${email}=    faizan@sch.ken42.com
${email2}=    amrut@sch.ken42.com
${meetingId}=    a03O000000Rnw5uIAB
${starttime}=    08:30:00.000Z
${startdate}=    2021-02-01

*** Test Cases ***

TestCase_001
    
    Create Session    Mysession        https://rahulshettyacademy.com
    ${headers1}=    Create Dictionary    Content-Type=text/xml
    ${queryParams1}=    Create Dictionary    key=qaclick123
    ${Req_Body1}=    Get File    D:/sel jars/Postbody.txt 
    ${Response1}=    Post Request    Mysession    //maps/api/place/add/json    data=${Req_Body1}    headers=${headers1}    params=${queryParams1}
    Log To Console    ${Response1}   
    

Student_Login
    Create Session    SSession    ${BaseUrl1}
    ${headers}=    Create Dictionary     Content-Type=application/x-www-form-urlencoded    Authorization=Basic d3lsZzAxa2ZfZUdXcDlLWjJXV2t5SzA0Y3lBYTo3aERrTjhWaTJCSGpXdG92MFViYWxTcGFNSElh
    ${Body}=    Create Dictionary    grant_type=client_credentials    validity_period=604800
    # ${queryParams1}=    Create Dictionary    emailId=student1@ken42.onmicrosoft.com
    ${Response}=    Post Request    SSession    /token    data=${Body}    headers=${headers}
    ${Status_code}=    Convert To String   ${Response.status_code}
    ${responce_body}=     To Json    ${Response.content} 
    ${accesstoken}=       Get Value From Json    ${responce_body}    $.access_token
    Log To Console    ${accesstoken}    
    Create Session    SSession    ${BaseUrl1}
    ${headers1}=    Create Dictionary    Authorization="Bearer ${accesstoken}"    Content-Type=text/xml
    ${queryparam}=    Create Dictionary    emailId=student1@ken42.onmicrosoft.com   
    ${Response}=    Get Request    SSession    /api/1.0.0/WhoAmI    headers=${headers1}    params=${queryparam}    
    
    
Student_Auth
    Create Session    asession    ${token_url}
    ${Response1}=    Get Request    asession    /azuretoken  
    ${accessToken}=    evaluate    $Response1.json().get("access_token")  
       
    # ${accesstoken1}=       Get Value From Json    ${responce_body}    access_token
    # ${token}=    Convert To String    ${accesstoken1}
    Log To Console    ${accessToken}  
    ${Bearer}=      Set Variable   Bearer
    ${token}=       catenate    Bearer    ${accessToken}
    Log to Console     ${token}
    Create Session    auth    ${BaseUrl2}          
    ${headers}=    Create Dictionary    Authorization=${token}    content-type=application/json    
    ${queryParam1}=    Create Dictionary    UniqueId=${email}    
    ${Response}=    Get Request   auth   /authenticate    headers=${headers}    params=${queryParam1}
    ${Auth_resp}=    Convert To String    ${Response.content}
    Should Be Equal As Strings    ${Response.status_code}    200 
    ${Contact}=    evaluate    $Response.json().get("Contact Id")   
    Log To Console    ${Contact}
    ${Response1}=    Get Request   auth   /whyiamhere/${Contact}   headers=${headers}
    ${why_resp}=    Convert To String    ${Response1.content}
    Should Be Equal As Strings    ${Response1.status_code}    200
    ${Response2}=    Get Request   auth   /getcourse/${Contact}   headers=${headers}
    # FOR    ${i}    IN    @{Response2.json()}
           # Log  ${i}
           # ${course_id}=    Get Variable Value    ${Response2.json()[i]['CourseOfferingID']}
           # Log    ${course_id}
    # END
    
    ${Course_resp}=    To Json    ${Response2.content}
    ${Courseoffer}=    Get Value From Json    ${Course_resp}    $..CourseOfferingID 
    ${Courseoffer1}=    Get From List    ${Courseoffer}    0
    # ${id}=    Set Variable    ${Courseoffer}
   
            
    Log To Console    ${Courseoffer}
    Should Be Equal As Strings    ${Response2.status_code}    200
    ${Response3}=    Get Request   auth   /getstudent/${Courseoffer1}  headers=${headers}
    ${Student_resp}=    Convert To String    ${Response3.content}
    Should Be Equal As Strings    ${Response3.status_code}    200
    ${program_resp}=    To Json    ${Response3.content}
    ${program}=    Get Value From Json    ${program_resp}    $..ProgramId 
    ${programid}=    Get From List    ${program}    0
    Log To Console    ${programid}    
    # ${Response4}=    Get Request    auth    /faculty/${programid}    headers=${headers}
    # ${Faculty_resp}=    Convert To String    ${Response4.content}
    # Should Be Equal As Strings    ${Response4.status_code}    200
    
Pfs_integration
    Create Session    asession    ${token_url}
    ${Response1}=    Get Request    asession    /azuretoken  
    ${accessToken}=    evaluate    $Response1.json().get("access_token")  
       
    # ${accesstoken1}=       Get Value From Json    ${responce_body}    access_token
    # ${token}=    Convert To String    ${accesstoken1}
    Log To Console    ${accessToken}  
    ${Bearer}=      Set Variable   Bearer
    ${token}=       catenate    Bearer    ${accessToken}
    Log to Console     ${token}
    Create Session    auth    ${BaseUrl2}          
    ${headers}=    Create Dictionary    Authorization=${token}    content-type=application/json    
    ${queryParam1}=    Create Dictionary    emailId=${email}    
    ${Response}=    Get Request   auth   /WhoAmI    headers=${headers}    params=${queryParam1}
    ${Auth_resp}=    Convert To String    ${Response.content}
    Should Be Equal As Strings    ${Response.status_code}    200 
    ${Contact}=    evaluate    $Response.json().get("ContactId")
    Log To Console    ${Contact}
        
    
    ${queryParam2}=    Create Dictionary    emailId=${email2}    
    ${fac_Response}=    Get Request   auth   /WhoAmI    headers=${headers}    params=${queryParam2}
    ${faculty_resp}=    Convert To String    ${fac_Response.content}
    Should Be Equal As Strings    ${fac_Response.status_code}    200 
    ${Contactid}=    evaluate    $fac_Response.json().get("ContactId")
    ${Name}=    Evaluate    $fac_Response.json().get("Name")   
    Log To Console    ${Contactid}
    Log To Console    ${Name}    
    
    ${Resp}=    Get Request   auth   /getcourse/${Contactid}   headers=${headers}
    ${Course_resp}=    To Json    ${Resp.content}
    ${Courseoffer}=    Get Value From Json    ${Course_resp}    $..CourseOfferingID 
    ${Courseoffer1}=    Get From List    ${Courseoffer}    0
    ${C_name}=    Get Value From Json    ${Course_resp}    $..Name
    ${Course_name}=    Get From List    ${C_name}    0    
    
    Create Session    isession    ${Int_url}
    ${headers}=    Create Dictionary    Authorization=${token}    content-type=application/json    
    ${queryParam3}=    Create Dictionary    meetingName=${Course_name}    meetingId=${meetingId}    fullName=${Name}    courseId=${Courseoffer1}    ContactId=${Contactid}    starttime=${starttime}    startdate=${startdate}
    ${Fac_class}=    Post Request    isession    /faculty    headers=${headers}    params=${queryParam3}
    ${int_resp}=    Convert To String    ${Fac_class.content}
    Should Be Equal As Strings    ${Fac_class.status_code}    200 
    ${Mod_link}=    evaluate    $Fac_class.json().get("moderatorLink")
    



Application_Portal
    Create Session    App    ${token_url}    
    ${token_Response}=    Get Request    App    /azuretoken  
    ${accessToken}=    evaluate    $token_Response.json().get("access_token")  
       
    # ${accesstoken1}=       Get Value From Json    ${responce_body}    access_token
    # ${token}=    Convert To String    ${accesstoken1}
    Log To Console    ${accessToken}  
    ${Bearer}=      Set Variable   Bearer
    ${token}=       catenate    Bearer    ${accessToken}
    Log to Console     ${token}
    Create Session    application    ${App_baseurl}
    ${headers}=    Create Dictionary    content-type=application/json    Authorization=${token}        
    ${acdemic_response}=    Get Request    application    /academic-program    headers=${headers}
    Should Be Equal As Strings    ${acdemic_response.status_code}    200
    ${academ_resp}=    To Json    ${acdemic_response.content}        
    ${Institue}=    Get Value From Json    ${academ_resp}    $..InstituteId 
    ${Institue_id}=    Get From List    ${Institue}    0
    Log To Console    ${Institue_id}
    ${contact_body}=    Get File    D:/App_Portal/Create_contact.txt
    ${contact_resp}=    Post Request    application    /create-contact    data=${contact_body}    headers=${headers}
    Should Be Equal As Strings    ${contact_resp.status_code}    200    
    ${Contactid}=    Evaluate    $contact_resp.json().get("ContactId")
    ${Applicant_Account}=    Evaluate    $contact_resp.json().get("ApplicantAccount")
    ${Relations_Account}=    Evaluate    $contact_resp.json().get("RelationsAccount")   
    Log To Console    ${Contactid}
    Log To Console    ${Applicant_Account}
    Log To Console    ${Relations_Account}
    ${app_body}=    Create Dictionary    First_Name=Narang    Last_Name=Mitra    Gender=Male    DOB=2011-09-22    applying_to=${Institue_id}    Nationality=Indian    Religion=Hindu    ContactId=${Contactid}    PreparerId=${Contactid}    ApplicantType=Foreigner    Caste=General    Academic_year=2021                     
	${App_resp}=    Post Request    application    /create-application    data=${app_body}    headers=${headers}
    Should Be Equal As Strings    ${App_resp.status_code}    200
    ${app_id}=    Evaluate    $App_resp.json().get("ApplicationId")
    Log To Console    ${app_id}    
    ${Rel_body}=    Create Dictionary    Id=0    RelationsAccount=${Relations_Account}    ContactId=${Contactid}    hed__RelatedContact__c=0    FirstName=Amar    LastName=Nath    Relationship=Father    Phone=9872229098    Email=Amar@gmail.com
    ${Rel_resp}=    Post Request    application    /Relationships    data=${Rel_body}    headers=${headers}
    Should Be Equal As Strings    ${Rel_resp.status_code}    200 
       
        


    
    
    
    
        
        
   
       
    
