# 🧾 AtheneX — Inventory Manager

**AtheneX** is a lightweight, offline-first inventory management app built with **Flutter** and **SQLite (sqflite)**.  
It helps users manage product listings, categories, quantities, and prices seamlessly — even without internet access.

---

## ✨ Features

- 🗂️ **Product Management**
    - Add, edit, delete, and search products.
    - Include multiple product images (from camera or gallery).
    - Supports rich descriptions and category assignment.

- 🏷️ **Category Management**
    - Preloaded default categories.
    - Add custom categories with icons.
    - Persistent local storage using SQLite.

- 💾 **Offline-First Architecture**
    - Uses **sqflite** for persistent local data.
    - Data remains after app restart.

- 💰 **Smart Formatting**
    - Naira (₦) currency formatting widget.
    - Automatic total calculations.

- 🖼️ **Visual Layout**
    - Product grid view with images.
    - Filter by category.
    - Clean Material UI with rounded inputs and light dropdowns.

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-------------|
| Frontend | Flutter |
| Database | sqflite |
| State Management | setState (lightweight) |
| Image Handling | image_picker |
| Notifications | fluttertoast |
| Utilities | path, path_provider |

---

## ⚙️ Local Setup

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/athenex.git
cd athenex
