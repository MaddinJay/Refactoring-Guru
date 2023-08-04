Assuming that we have following situtation:

![Accounting - Example](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Factory_Method/Real_World/Factory_Method%20-%20Real_World_Example.PNG)

An accountant wants to create two types of bank accounts:

- Personal bank account
- Business bank account

For the creation of each bank account three steps have to be executed:

- Validation of user identity
- Calculation of the interest rate
- Registration of the account

These steps are handled differently regarding the type of the bank account. The accountant wants to avoid duplication in her or his workflow and does not want to care about which type is processed in the moment.

To avoid code duplication and make the accountant workflow not dependent on the type of the bank account type, we introduce the Factory Method Pattern. 

## Class Accountant (user of the bank account classes)
