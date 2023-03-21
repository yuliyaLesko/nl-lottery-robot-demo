*** Settings ***
Library     SeleniumLibrary
Library     FakerLibrary
Library     String
Library     Collections
Resource    ../Resources/keywords.robot
Resource    ../Pages/mainPage.robot

*** Test Cases ***
Verify correct prizes calculation for entered ticket numbers
    [Documentation]    This test case verifies that prize of checked tickets in Eurojackpot webpage is returned according to calculation rules
    Open Browser    ${mainPage}    Chrome
    Consent cookies pop up
    Wait Until Element Is Visible    id:draw-select
    ${randomValue}=    Select random date
    Select from list by Index    id:draw-select    ${randomValue}
    Sleep    8

    Fill first number
    Run Keyword And Ignore Error    Scroll Element Into View    ${banner}
    Click Element    ${addNewTicketButton}

    Fill second number
    Run Keyword And Ignore Error    Scroll Element Into View    ${banner}
    Click Element    ${checkTicketButton}

    ${errorMessage1}=    Run Keyword And Return Status    Element Should Be Visible    id:ticket-error-0
    ${errorMessage2}=    Run Keyword And Return Status    Element Should Be Visible    id:ticket-error-1

    ${counter}=    Set Variable    0
    WHILE    ${errorMessage1}== True
        Fill first number
        Run Keyword And Ignore Error    Scroll Element Into View    ${banner}
        Click Element    ${checkTicketButton}
        ${counter}=    Evaluate    ${counter}+1
        Log To Console    Error message is visible, refilling the number...
        IF    ${counter} > 10            BREAK
        ${errorMessage1}=    Run Keyword And Return Status    Element Should Be Visible    id:ticket-error-0
    END

    ${counter}=    Set Variable    0
    WHILE    ${errorMessage2}== True
        Fill second number
        Run Keyword And Ignore Error    Scroll Element Into View    ${banner}
        Click Element    ${checkTicketButton}
        ${counter}=    Evaluate    ${counter}+1
        Log To Console    Error message is visible, refilling the number...
        IF    ${counter} > 10            BREAK
        ${errorMessage2}=    Run Keyword And Return Status    Element Should Be Visible    id:ticket-error-1
    END

    # wait till numbers are defined
    Sleep    15
    Run Keyword And Ignore Error    Scroll Element Into View    //a[contains(text(), 'Koop nieuwe loten')]
    # validate price calculation for each ticket
    ${prize4_2}=    Get Text
    ...    //th[contains(text(), '4 getallen + 2 bonusgetallen goed')]/ancestor::tr/td[contains(@class, 'prize-table__winning-sum')]
    ${prize4_2}=    Evaluate    '${prize4_2}'.replace(' ','')
    ${prize4_2}=    Evaluate    '${prize4_2}'.replace('€','')
    Element Text Should Be    (//li[@class="ticketchecker__ticket"]/span)[1]    €${prize4_2} gewonnen!
    ${prize3_2}=    Get Text
    ...    //th[contains(text(), '4 getallen + 1 bonusgetal goed')]/ancestor::tr/td[contains(@class, 'prize-table__winning-sum')]
    ${prize3_2}=    Evaluate    '${prize3_2}'.replace(' ','')
    ${prize3_2}=    Evaluate    '${prize3_2}'.replace('€','')
    Element Text Should Be    (//li[@class="ticketchecker__ticket"]/span)[2]    €${prize3_2} gewonnen!

    #Validate total prize calculation
    ${prizeTotal}=    Get Text    //div[@class='animated-prize animated-prize--ready']
    ${prizeTotal}=    Replace String    ${prizeTotal}    \n    ${EMPTY}
    ${prizeTotal}=    Evaluate    '${prizeTotal}'.replace('€', '')
    ${prizeTotal}=    Evaluate    '${prizeTotal}'.replace('.', '')
    ${prizeTotal}=    Evaluate    '${prizeTotal}'.replace(',', '.')

    ${prize4_2}=    Evaluate    '${prize4_2}'.replace('.','')
    ${prize4_2}=    Evaluate    '${prize4_2}'.replace(',','.')
    ${prize3_2}=    Evaluate    '${prize3_2}'.replace(',','.')

    ${calculatedTotalPrice}=    Evaluate    ${prize4_2}+${prize3_2}
    ${calculatedTotalPrice}=    Convert To Number    ${calculatedTotalPrice}    1
    ${prizeTotal}=    Convert To Number    ${prizeTotal}
    Should Be Equal    ${calculatedTotalPrice}    ${prizeTotal}
    Sleep    5
    Capture Page Screenshot
    Close Browser
