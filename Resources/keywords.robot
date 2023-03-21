*** Settings ***
Library     SeleniumLibrary
Library     FakerLibrary
Library     String
Library     Collections


*** Keywords ***
Select random date
    ${randomValue}=    Random Int    max=98
    RETURN    ${randomValue}

Consent cookies pop up
    Wait Until Element Is Visible    //button[text()='Akkoord']
    ${popUpExists}=    Run Keyword And Return Status    Element Should Be Visible    //button[text()='Akkoord']
    IF    ${popUpExists} == True    Click Button    //button[text()='Akkoord']
    Element Should Not Be Visible    //div[@class='cookie-modal base-tile']

Fill first number
    @{elems}=    Get WebElements    xpath://span[contains(@class, 'number-bar')]/span[not(@style)]
    ${counter}=    Set Variable    0
    ${counterBonus}=    Set Variable    0

    FOR    ${element}    IN    @{elems}
        IF    ${counter} > 4
            Input Text    id:ticket-0-bonus-number-${counterBonus}    text:${element.text}
            ${counterBonus}=    Evaluate    ${counterBonus}+1
        ELSE IF    ${counter} == 4
            ${randomValue}=    Evaluate    random.sample(range(1, 50), 1)
            Input Text    id:ticket-0-number-${counter}    text:${randomValue}
        ELSE
            Input Text    id:ticket-0-number-${counter}    text:${element.text}
        END
        ${counter}=    Evaluate    ${counter}+1
    END

Fill second number
    @{elems}=    Get WebElements    xpath://span[contains(@class, 'number-bar')]/span[not(@style)]
    ${counter}=    Set Variable    0
    ${counterBonus}=    Set Variable    0
    ${bonusNumber}=    Set Variable    0

    FOR    ${element}    IN    @{elems}
        IF    ${counter} == 5
            Input Text    id:ticket-1-bonus-number-${counterBonus}    text:${element.text}
            ${bonusNumber}=    Set Variable    ${element.text}
            ${counterBonus}=    Evaluate    ${counterBonus}+1
        ELSE IF    ${counter} == 6
            ${uniqueValue}=    Evaluate    ${element.text}-1
            IF    ${uniqueValue}==${bonusNumber}
                ${uniqueValue}=    Evaluate    ${bonusNumber}-1
                Input Text    id:ticket-1-bonus-number-${counterBonus}    text:${uniqueValue}
            ELSE IF    ${uniqueValue}== 0
                ${uniqueValue}=    Evaluate    ${uniqueValue}+2
                Input Text    id:ticket-1-bonus-number-${counterBonus}    text:${uniqueValue}
                ${counterBonus}=    Evaluate    ${counterBonus}+1
            ELSE
                Input Text    id:ticket-1-bonus-number-${counterBonus}    text:${uniqueValue}
                ${counterBonus}=    Evaluate    ${counterBonus}+1
            END
        ELSE IF    ${counter} == 4
            ${randomValue}=    Evaluate    random.sample(range(1, 50), 1)
            Input Text    id:ticket-1-number-${counter}    text:${randomValue}
        ELSE
            Input Text    id:ticket-1-number-${counter}    text:${element.text}
        END
        ${counter}=    Evaluate    ${counter}+1
    END
