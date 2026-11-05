# TechZone Electronics — Customer & Sales Management System
### Assignment 1 | Dart Console-Based Prototype

---

## 1. Organization / Institution Background

| Detail | Description |
|--------|-------------|
| **Name** | TechZone Electronics |
| **Type** | Retail Electronics Shop |
| **Main Activities** | Buying and selling consumer electronics (smartphones, laptops, accessories, audio equipment) |
| **Department** | Sales & Customer Service Department |
| **Current Method** | Customer details are written in paper logbooks; sales receipts are handwritten and filed in folders; purchase history is tracked manually per staff member with no central record |

---

## 2. Problem Identification

### The Existing Problem
TechZone Electronics relies entirely on **manual, paper-based processes** to manage customer information and record daily sales transactions. There is no centralised system linking a customer to their purchase history.

### Causes of the Problem
- No digital infrastructure in the sales department
- Each cashier maintains their own informal logbook
- No standardised format for recording customer or product data

### Effects of the Problem
- Customer records are frequently lost or duplicated
- Billing errors occur when prices are calculated manually
- Staff cannot quickly look up a customer's past purchases
- Loyalty rewards cannot be tracked accurately, leading to customer dissatisfaction
- Management has no reliable data for generating sales reports or restocking decisions

### Who Is Affected
- **Customers** — experience billing errors and cannot claim loyalty rewards
- **Cashiers/Sales Staff** — waste time searching through paper records
- **Shop Manager** — cannot generate accurate daily or monthly sales reports
- **Business Owner** — makes restocking and pricing decisions based on unreliable data

### Why a Software Solution Is Necessary
A digital Customer & Sales Management System would centralise all records, eliminate manual errors, enable instant lookup of customer and sale data, automate loyalty point tracking, and provide management with real-time sales reports — all of which directly improve the shop's efficiency and customer experience.

---

## 3. Proposed Solution

### Name of Proposed System
**TechZone Customer & Sales Management System (CSMS)**

### Purpose of the System
A console-based Dart prototype that manages customer registration, records product sales transactions, tracks each customer's purchase history, and generates sales summary reports for the shop manager.

### Target Users
| User | Role |
|------|------|
| Cashier / Sales Staff | Registers customers and records sales |
| Shop Manager | Views reports, applies discounts, monitors customers |
| Customer (indirect) | Benefits from accurate records and loyalty rewards |

### Major Features
- Register and manage customer profiles
- Record product sales transactions linked to a customer
- View a customer's full purchase history
- Apply percentage discounts to any sale
- Earn and redeem loyalty points (1 point per $1 spent)
- View a sales summary report broken down by product category
- Update customer contact information
- Look up any sale by its unique Sale ID

### Expected Benefits
- Eliminates paper records and manual billing errors
- Instant lookup of customer or sale information
- Automated loyalty point calculation
- Management reports generated on demand
- Scalable foundation for a future Flutter mobile application with Supabase database

---

## 4. Functional & Non-Functional Requirements

### Functional Requirements
| # | Requirement |
|---|-------------|
| FR1 | The system shall register a new customer with a unique ID, name, email, phone, and address |
| FR2 | The system shall record a sale transaction (product, category, quantity, unit price, date) linked to a customer |
| FR3 | The system shall display a customer's full profile and their purchase history |
| FR4 | The system shall list all registered customers with their total spending and loyalty points |
| FR5 | The system shall look up and display any sale by its unique Sale ID |
| FR6 | The system shall apply a percentage discount to a sale and show the discounted total |
| FR7 | The system shall update a customer's phone number |
| FR8 | The system shall allow a customer to redeem their loyalty points for a discount |
| FR9 | The system shall generate a sales summary showing total transactions, grand revenue, and revenue by category |
| FR10 | The system shall prevent duplicate Customer IDs and Sale IDs |

### Non-Functional Requirements
| # | Requirement |
|---|-------------|
| NFR1 | **Usability** — Menu-driven interface with numbered options; all prompts are clearly labelled |
| NFR2 | **Reliability** — Input is validated; empty fields and non-numeric entries are rejected with a warning |
| NFR3 | **Maintainability** — Code is modular; each feature is in its own clearly named function |
| NFR4 | **Performance** — All operations (lookup, register, report) complete immediately with no delay |
| NFR5 | **Portability** — Runs on any platform with the Dart SDK installed (Windows, macOS, Linux) |
| NFR6 | **Data Integrity** — Loyalty points are calculated automatically to prevent human error |

---

## 5. Class Design Overview

```
Customer                             Sale
─────────────────────────────        ─────────────────────────────
Attributes:                          Attributes:
  customerId  : String                 saleId       : String
  fullName    : String                 productName  : String
  email       : String                 category     : String
  phoneNumber : String                 quantity     : int
  address     : String                 unitPrice    : double
  loyaltyPoints : int                  saleDate     : String
                                       customerId   : String
Instance Methods:
  displayInfo()                      Instance Methods:
  makePurchase(Sale)  ◄──────────      displayInfo()
  displayPurchaseHistory()             calculateTotal()
  updatePhone(String)                  applyDiscount(double)
  redeemPoints(int)
                                     Static Members:
Static Members:                        totalSalesCount : int
  customerRegistry : Map               allSales : List<Sale>
  registerCustomer(Customer)           reportSalesSummary()
  findById(String)                     findById(String)
  displayAllCustomers()

Data Structures Used:
  Map<String, Customer>  — customerRegistry  (O(1) lookup by ID)
  List<Sale>             — purchaseHistory   (per-customer order history)
  List<Sale>             — allSales          (global transaction log)
  Map<String, double>    — category totals   (used in sales report)
```

**Object Interaction:** `Customer.makePurchase(Sale)` links a `Sale` object directly into the customer's `List<Sale> purchaseHistory`, establishing a clear one-to-many relationship between a customer and their transactions.

---

## 6. How to Run the Program

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) installed (version 2.18 or later)

### Run from Terminal
```bash
# Navigate to the project directory
cd path/to/project

# Run the program
dart run main.dart
```

### Sample Session
```
================================================================
  TECHZONE ELECTRONICS -- CUSTOMER & SALES MANAGEMENT SYSTEM
================================================================
  1.  Register New Customer
  2.  Record New Sale
  3.  View Customer Profile & Purchase History
  4.  View All Registered Customers
  5.  View Sale by ID
  6.  Apply Discount to Sale
  7.  Update Customer Phone Number
  8.  Redeem Loyalty Points
  9.  Sales Summary Report
  10. Exit
================================================================

  Enter choice (1-10): 3
  Customer ID: C001

================================================================
                   CUSTOMER PROFILE
================================================================
  Customer ID    : C001
  Full Name      : Aminata Sesay
  Email          : aminata@email.com
  Phone          : 076-111-2233
  Address        : 12 Wilberforce St, Freetown
  Loyalty Points : 1130 pts
  Total Purchases: 2 transaction(s)
  Total Spent    : $1130.00
```

### Demo Data (pre-loaded on startup)
| Customer ID | Name | Purchases |
|-------------|------|-----------|
| C001 | Aminata Sesay | Samsung Galaxy A54, HP Pavilion Laptop 15 |
| C002 | David Koroma | Sony WH-1000XM5 Headphones ×2 |

---

## 7. Brief Explanation of the Program

The program is structured around **two core classes** that mirror the real-world entities in the shop:

**`Sale` class** models a single product transaction. It stores the product name, category, quantity, unit price, and sale date. Its `calculateTotal()` method computes the cost, `applyDiscount()` reduces the total by a given percentage, and the static method `reportSalesSummary()` iterates over the global `allSales` list to produce a revenue breakdown by category. A static counter `totalSalesCount` increments every time a new `Sale` is constructed.

**`Customer` class** models a registered shopper. Each customer holds a `List<Sale>` called `purchaseHistory` — when `makePurchase(Sale)` is called, the sale is appended to this list and loyalty points are automatically calculated (`$1 spent = 1 point`). The static `Map<String, Customer> customerRegistry` provides O(1) lookup by customer ID. `redeemPoints()` deducts points and calculates the equivalent discount value.

The two classes **interact** through `Customer.makePurchase(Sale)`, creating a direct object-to-object relationship — a `Customer` object holds references to `Sale` objects, demonstrating composition and object collaboration.

The `main()` function seeds two customers and three sales to provide meaningful demo data from the first run, then enters an infinite menu loop that dispatches to dedicated handler functions (`registerCustomer()`, `recordSale()`, etc.), keeping the code modular and readable.

---

## 8. Project Structure

```
project/
│
└── main.dart          ← Full Dart console prototype (single file)
└── README.md          ← This documentation file
```

---

## 9. Development Flow

```
Real-World Problem  →  Problem Analysis  →  Proposed Solution
       ↓
System Requirements  →  Dart Prototype  →  Flutter Application
       ↓
Supabase Database  →  Complete Mobile Application
```

> **Assignment 1** covers: Problem Analysis, Proposed Solution, Requirements, and Dart Prototype.

---

*Assignment 1 — Dart Console Prototype | TechZone Electronics | Customer & Sales Management System*
