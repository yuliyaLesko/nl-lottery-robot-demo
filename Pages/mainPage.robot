*** Settings ***
Library     SeleniumLibrary
Library     FakerLibrary
Library     String
Library     Collections

*** Variables ***
${mainPage}     https://eurojackpot.nederlandseloterij.nl/uitslag
${banner}    //a[@class='banner-block__link']
${checkTicketButton}    //button[text()='Controleer jouw lot(en)']
${addNewTicketButton}    //button[contains(text(), 'Nog een lot toevoegen')]