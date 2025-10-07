
class Location {

     // @param {string} address
     // @param {boolean} is_open
     // @type {number} profit (derived)
     // @type {number} staff_count (derived)

    constructor(address, is_open) {
        this.address = address; // PK
        this.is_open = is_open;
    }

    get profit(){}
    get staff_count(){}
}

class Document {

     // @param {string} title
     // @param {string} loc_address
     // @param {Date} issue_date (optional)
     // @param {Date} expire_date (optional)
     // @param {boolean} is_active_m (optional)
     // @type {boolean} is_active (derived)

    constructor(title, loc_address, issue_date, expire_date,is_active_m) {
        this.title = title; //pk
        this.loc_address = loc_address; // FK
        this.issue_date = issue_date || null;
        this.expire_date = expire_date || null;
        this.is_active_m = is_active_m || null;
    }

    get is_active() {
        if (this.is_active_m !== null) {
            return this.is_active_m;
        }
        //...
    }

}

class Employee {

     // @param {string} full_name
     // @param {number} age
     // @param {string} shift
     // @param {string} position
     // @param {number} salary
     // @param {string} phone
     // @param {string} loc_address

    constructor(full_name, age, shift, position, salary, phone, loc_address, doc_title) {
        this.full_name = full_name; // PK
        this.age = age;
        this.shift = shift;
        this.position = position;
        this.salary = salary;
        this.phone = phone;
        this.loc_address = loc_address; //FK
    }
}

class EmployeeDoc {

    // @param {object} employeeInst
    // @param {object} documentInst
    // @type {string} employeeInst.full_name
    // @type {string} documentInst.title
    // @type {string} documentInst.loc_address

    constructor(employeeInst,documentInst) {
        this.employeeInst = employeeInst;
        this.documentInst = documentInst;
    }

    get employee_name() {
        return this.employeeInst.full_name; //pk,FK
    }
    get document_title() {
        return this.documentInst.title; //pk,FK
    }
    get loc_address() {
        return this.documentInst.loc_address; //pk,FK
    }
}

class Menu {

     // @param {string} title
     // @param {string} loc_address

    constructor(title, loc_address) {
        this.title = title; //PK
        this.loc_address = loc_address; //FK
    }
}

class Item {

     // @param {string} title
     // @param {number} current_price
     // @param {string} menu_title
     // @param {string} recipe (optional)

    constructor(title, current_price, menu_title, recipe) {
        this.title = title; //PK
        this.current_price = current_price;
        this.menu_title = menu_title; //FK
        this.recipe = recipe || null;
    }
}

class Sold {

    // @param {data} date
    // @param {string} item_title
    // @param {number} amount
    // @param {number} price

    constructor(date, item_title, amount, price) {
        this.date = date; //pk
        this.item_title = item_title; //pk,FK
        this.amount = amount;
        this.price = price;
    }
}