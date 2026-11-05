// ============================================================
//  CUSTOMER & SALES MANAGEMENT SYSTEM
//  A Dart Console-Based Prototype
//
//  Organization : TechZone Electronics – Sales Department
//  Problem      : The shop manages customer records and daily
//                 sales transactions using paper logbooks and
//                 manual receipts, leading to lost records,
//                 billing errors, and no purchase history.
//  Solution     : A console-based system to register customers,
//                 record sales transactions, track purchase
//                 history, and generate basic sales reports.
//
//  Assignment 1 – Dart Prototype
// ============================================================

import 'dart:io';

// ─────────────────────────────────────────────────────────────
//  CLASS 1 : Sale
//  Represents a single sales transaction at the electronic shop.
// ─────────────────────────────────────────────────────────────
class Sale {
  // ---------- Attributes ----------
  String saleId;
  String productName;
  String category;       // e.g. "Laptop", "Phone", "Accessory"
  int    quantity;
  double unitPrice;      // price per single item (USD)
  String saleDate;       // format: YYYY-MM-DD
  String customerId;     // links sale to a Customer

  // Static counter – tracks total number of sales recorded
  static int totalSalesCount = 0;

  // Static list – holds every Sale ever created (all-sales registry)
  static List<Sale> allSales = [];

  // ---------- Constructor ----------
  Sale({
    required this.saleId,
    required this.productName,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.saleDate,
    required this.customerId,
  }) {
    totalSalesCount++;
    allSales.add(this);
  }

  // ---------- Instance Method: calculate total cost ----------
  double calculateTotal() {
    return quantity * unitPrice;
  }

  // ---------- Instance Method: display sale details ----------
  void displayInfo() {
    print('  +-- Sale Record ------------------------------------------------');
    print('  |  Sale ID      : $saleId');
    print('  |  Product      : $productName');
    print('  |  Category     : $category');
    print('  |  Quantity     : $quantity unit(s)');
    print('  |  Unit Price   : \$${unitPrice.toStringAsFixed(2)}');
    print('  |  Total Cost   : \$${calculateTotal().toStringAsFixed(2)}');
    print('  |  Date         : $saleDate');
    print('  |  Customer ID  : $customerId');
    print('  +---------------------------------------------------------------');
  }

  // ---------- Instance Method: apply a discount ----------
  double applyDiscount(double percentOff) {
    double discounted = calculateTotal() * (1 - percentOff / 100);
    print('  [OK] Discount of ${percentOff.toStringAsFixed(0)}% applied.');
    print('       Original: \$${calculateTotal().toStringAsFixed(2)}'
        '  -->  After discount: \$${discounted.toStringAsFixed(2)}');
    return discounted;
  }

  // ---------- Static Method: report overall sales summary ----------
  static void reportSalesSummary() {
    print('\n  ================================================================');
    print('                    OVERALL SALES SUMMARY                       ');
    print('  ================================================================');
    print('  Total Transactions : $totalSalesCount');
    if (allSales.isEmpty) {
      print('  No sales recorded yet.');
      return;
    }
    double grandTotal = allSales.fold(0, (sum, s) => sum + s.calculateTotal());
    print('  Grand Total Revenue: \$${grandTotal.toStringAsFixed(2)}');
    print('  ----------------------------------------------------------------');
    // breakdown by category
    Map<String, double> byCategory = {};
    for (Sale s in allSales) {
      byCategory[s.category] =
          (byCategory[s.category] ?? 0) + s.calculateTotal();
    }
    print('  Revenue by Category:');
    byCategory.forEach((cat, total) {
      print('    $cat : \$${total.toStringAsFixed(2)}');
    });
    print('  ================================================================');
  }

  // ---------- Static Method: find sale by ID ----------
  static Sale? findById(String id) {
    for (Sale s in allSales) {
      if (s.saleId == id) return s;
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────
//  CLASS 2 : Customer
//  Represents a registered customer of the electronic shop.
//  Interacts with Sale objects via a purchase history list.
// ─────────────────────────────────────────────────────────────
class Customer {
  // ---------- Attributes ----------
  String customerId;
  String fullName;
  String email;
  String phoneNumber;
  String address;
  int    loyaltyPoints;   // 1 point per $1 spent

  // List (data structure) – stores all Sale objects for this customer
  List<Sale> purchaseHistory = [];

  // Static Map (data structure) – registry of all customers: ID -> Customer
  static Map<String, Customer> customerRegistry = {};

  // ---------- Constructor ----------
  Customer({
    required this.customerId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.loyaltyPoints = 0,
  });

  // ---------- Instance Method: display customer profile ----------
  void displayInfo() {
    print('\n  ================================================================');
    print('                   CUSTOMER PROFILE                             ');
    print('  ================================================================');
    print('  Customer ID    : $customerId');
    print('  Full Name      : $fullName');
    print('  Email          : $email');
    print('  Phone          : $phoneNumber');
    print('  Address        : $address');
    print('  Loyalty Points : $loyaltyPoints pts');
    print('  Total Purchases: ${purchaseHistory.length} transaction(s)');
    double totalSpent =
        purchaseHistory.fold(0, (sum, s) => sum + s.calculateTotal());
    print('  Total Spent    : \$${totalSpent.toStringAsFixed(2)}');
  }

  // ---------- Instance Method: record a new purchase ----------
  void makePurchase(Sale sale) {
    purchaseHistory.add(sale);
    int pointsEarned = sale.calculateTotal().toInt();
    loyaltyPoints   += pointsEarned;
    print('\n  [OK] Sale "${sale.saleId}" recorded for $fullName.');
    print('       +$pointsEarned loyalty points earned.'
        ' Total: $loyaltyPoints pts.');
  }

  // ---------- Instance Method: display full purchase history ----------
  void displayPurchaseHistory() {
    displayInfo();
    print('\n  ---- Purchase History ------------------------------------------');
    if (purchaseHistory.isEmpty) {
      print('  [WARN] No purchases recorded for $fullName yet.');
    } else {
      for (int i = 0; i < purchaseHistory.length; i++) {
        print('\n  Purchase #${i + 1}');
        purchaseHistory[i].displayInfo();
      }
    }
  }

  // ---------- Instance Method: update phone number ----------
  void updatePhone(String newPhone) {
    phoneNumber = newPhone;
    print('  [OK] Phone for $fullName updated to: $phoneNumber');
  }

  // ---------- Instance Method: redeem loyalty points ----------
  void redeemPoints(int points) {
    if (points > loyaltyPoints) {
      print('  [WARN] Not enough loyalty points.'
          ' You have $loyaltyPoints pts.');
      return;
    }
    loyaltyPoints -= points;
    double discount = points * 0.01; // 1 pt = $0.01 discount
    print('  [OK] $points pts redeemed.'
        ' Discount earned: \$${discount.toStringAsFixed(2)}.'
        ' Remaining points: $loyaltyPoints pts.');
  }

  // ---------- Static Method: register a customer ----------
  static void registerCustomer(Customer customer) {
    customerRegistry[customer.customerId] = customer;
    print('  [OK] Customer "${customer.fullName}" registered'
        ' (ID: ${customer.customerId}).');
  }

  // ---------- Static Method: find customer by ID ----------
  static Customer? findById(String id) {
    return customerRegistry[id];
  }

  // ---------- Static Method: list all customers ----------
  static void displayAllCustomers() {
    print('\n  ================================================================');
    print('                   ALL REGISTERED CUSTOMERS                     ');
    print('  ================================================================');
    if (customerRegistry.isEmpty) {
      print('  [WARN] No customers registered yet.');
    } else {
      int index = 1;
      customerRegistry.forEach((id, c) {
        double spent = c.purchaseHistory.fold(
            0, (sum, s) => sum + s.calculateTotal());
        print('  $index. ID: $id  |  Name: ${c.fullName}'
            '  |  Purchases: ${c.purchaseHistory.length}'
            '  |  Spent: \$${spent.toStringAsFixed(2)}'
            '  |  Points: ${c.loyaltyPoints}');
        index++;
      });
    }
    print('  ================================================================');
  }
}

// ─────────────────────────────────────────────────────────────
//  HELPER: Read non-empty string from console
// ─────────────────────────────────────────────────────────────
String readLine(String prompt) {
  while (true) {
    stdout.write('  $prompt');
    String? input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) return input.trim();
    print('  [WARN] Input cannot be empty. Try again.');
  }
}

// ─────────────────────────────────────────────────────────────
//  HELPER: Read integer from console
// ─────────────────────────────────────────────────────────────
int readInt(String prompt) {
  while (true) {
    stdout.write('  $prompt');
    int? v = int.tryParse(stdin.readLineSync() ?? '');
    if (v != null) return v;
    print('  [WARN] Enter a valid whole number.');
  }
}

// ─────────────────────────────────────────────────────────────
//  HELPER: Read double from console
// ─────────────────────────────────────────────────────────────
double readDouble(String prompt) {
  while (true) {
    stdout.write('  $prompt');
    double? v = double.tryParse(stdin.readLineSync() ?? '');
    if (v != null && v >= 0) return v;
    print('  [WARN] Enter a valid positive number.');
  }
}

// ─────────────────────────────────────────────────────────────
//  MENU: Register New Customer
// ─────────────────────────────────────────────────────────────
void registerCustomer() {
  print('\n  -- Register New Customer ----------------------------------------');
  String id = readLine('Customer ID (e.g. C001) : ');

  if (Customer.customerRegistry.containsKey(id)) {
    print('  [WARN] Customer ID "$id" already exists.');
    return;
  }

  String name    = readLine('Full Name               : ');
  String email   = readLine('Email Address           : ');
  String phone   = readLine('Phone Number            : ');
  String address = readLine('Address                 : ');

  Customer c = Customer(
    customerId  : id,
    fullName    : name,
    email       : email,
    phoneNumber : phone,
    address     : address,
  );

  Customer.registerCustomer(c);
}

// ─────────────────────────────────────────────────────────────
//  MENU: Record a New Sale
// ─────────────────────────────────────────────────────────────
void recordSale() {
  print('\n  -- Record New Sale -----------------------------------------------');
  String custId = readLine('Customer ID        : ');

  Customer? customer = Customer.findById(custId);
  if (customer == null) {
    print('  [WARN] No customer found with ID "$custId".');
    return;
  }

  String saleId  = readLine('Sale ID (e.g. S001)    : ');
  if (Sale.findById(saleId) != null) {
    print('  [WARN] Sale ID "$saleId" already exists.');
    return;
  }

  String product  = readLine('Product Name           : ');
  String category = readLine('Category (e.g. Laptop) : ');
  int    qty      = readInt ('Quantity               : ');
  double price    = readDouble('Unit Price (\$)       : ');
  String date     = readLine('Sale Date (YYYY-MM-DD) : ');

  Sale sale = Sale(
    saleId      : saleId,
    productName : product,
    category    : category,
    quantity    : qty,
    unitPrice   : price,
    saleDate    : date,
    customerId  : custId,
  );

  customer.makePurchase(sale);
}

// ─────────────────────────────────────────────────────────────
//  MENU: View Customer Profile & Purchase History
// ─────────────────────────────────────────────────────────────
void viewCustomer() {
  print('\n  -- View Customer Record -----------------------------------------');
  String id = readLine('Customer ID: ');

  Customer? customer = Customer.findById(id);
  if (customer == null) {
    print('  [WARN] No customer found with ID "$id".');
    return;
  }

  customer.displayPurchaseHistory();
}

// ─────────────────────────────────────────────────────────────
//  MENU: View Sale by ID
// ─────────────────────────────────────────────────────────────
void viewSale() {
  print('\n  -- View Sale Record ---------------------------------------------');
  String id = readLine('Sale ID: ');

  Sale? sale = Sale.findById(id);
  if (sale == null) {
    print('  [WARN] No sale found with ID "$id".');
    return;
  }

  sale.displayInfo();
}

// ─────────────────────────────────────────────────────────────
//  MENU: Apply Discount to a Sale
// ─────────────────────────────────────────────────────────────
void applyDiscount() {
  print('\n  -- Apply Discount -----------------------------------------------');
  String id = readLine('Sale ID  : ');

  Sale? sale = Sale.findById(id);
  if (sale == null) {
    print('  [WARN] No sale found with ID "$id".');
    return;
  }

  double pct = readDouble('Discount % (e.g. 10): ');
  sale.applyDiscount(pct);
}

// ─────────────────────────────────────────────────────────────
//  MENU: Update Customer Phone
// ─────────────────────────────────────────────────────────────
void updatePhone() {
  print('\n  -- Update Customer Phone ----------------------------------------');
  String id = readLine('Customer ID        : ');

  Customer? customer = Customer.findById(id);
  if (customer == null) {
    print('  [WARN] No customer found with ID "$id".');
    return;
  }

  String newPhone = readLine('New Phone Number   : ');
  customer.updatePhone(newPhone);
}

// ─────────────────────────────────────────────────────────────
//  MENU: Redeem Loyalty Points
// ─────────────────────────────────────────────────────────────
void redeemPoints() {
  print('\n  -- Redeem Loyalty Points ----------------------------------------');
  String id = readLine('Customer ID : ');

  Customer? customer = Customer.findById(id);
  if (customer == null) {
    print('  [WARN] No customer found with ID "$id".');
    return;
  }

  print('  Current loyalty points: ${customer.loyaltyPoints} pts');
  int pts = readInt('Points to redeem    : ');
  customer.redeemPoints(pts);
}

// ─────────────────────────────────────────────────────────────
//  MAIN: Entry Point – seeds demo data & runs menu loop
// ─────────────────────────────────────────────────────────────
void main() {
  // ---- Seed demo data -----------------------------------------
  Customer c1 = Customer(
    customerId  : 'C001',
    fullName    : 'Aminata Sesay',
    email       : 'aminata@email.com',
    phoneNumber : '076-111-2233',
    address     : '12 Wilberforce St, Freetown',
  );

  Customer c2 = Customer(
    customerId  : 'C002',
    fullName    : 'David Koroma',
    email       : 'david.k@email.com',
    phoneNumber : '078-445-6677',
    address     : '5 Siaka Stevens St, Freetown',
  );

  Customer.registerCustomer(c1);
  Customer.registerCustomer(c2);

  Sale s1 = Sale(
    saleId      : 'S001',
    productName : 'Samsung Galaxy A54',
    category    : 'Smartphone',
    quantity    : 1,
    unitPrice   : 380.00,
    saleDate    : '2024-10-01',
    customerId  : 'C001',
  );

  Sale s2 = Sale(
    saleId      : 'S002',
    productName : 'HP Pavilion Laptop 15',
    category    : 'Laptop',
    quantity    : 1,
    unitPrice   : 750.00,
    saleDate    : '2024-10-05',
    customerId  : 'C001',
  );

  Sale s3 = Sale(
    saleId      : 'S003',
    productName : 'Sony WH-1000XM5 Headphones',
    category    : 'Accessory',
    quantity    : 2,
    unitPrice   : 120.00,
    saleDate    : '2024-10-10',
    customerId  : 'C002',
  );

  c1.makePurchase(s1);
  c1.makePurchase(s2);
  c2.makePurchase(s3);

  // ---- Main Menu Loop ----------------------------------------
  while (true) {
    print('\n');
    print('  ================================================================');
    print('    TECHZONE ELECTRONICS -- CUSTOMER & SALES MANAGEMENT SYSTEM  ');
    print('  ================================================================');
    print('  1.  Register New Customer');
    print('  2.  Record New Sale');
    print('  3.  View Customer Profile & Purchase History');
    print('  4.  View All Registered Customers');
    print('  5.  View Sale by ID');
    print('  6.  Apply Discount to Sale');
    print('  7.  Update Customer Phone Number');
    print('  8.  Redeem Loyalty Points');
    print('  9.  Sales Summary Report');
    print('  10. Exit');
    print('  ================================================================');

    stdout.write('\n  Enter choice (1-10): ');
    String? choice = stdin.readLineSync();

    switch (choice?.trim()) {
      case '1':
        registerCustomer();
        break;
      case '2':
        recordSale();
        break;
      case '3':
        viewCustomer();
        break;
      case '4':
        Customer.displayAllCustomers();
        break;
      case '5':
        viewSale();
        break;
      case '6':
        applyDiscount();
        break;
      case '7':
        updatePhone();
        break;
      case '8':
        redeemPoints();
        break;
      case '9':
        Sale.reportSalesSummary();
        break;
      case '10':
        print('\n  Thank you for using TechZone Sales System. Goodbye!\n');
        exit(0);
      default:
        print('  [WARN] Invalid option. Please enter 1 to 10.');
    }
  }
}
