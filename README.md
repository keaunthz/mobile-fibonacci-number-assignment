# Fibonacci Scrollable List

## Overview
This project implements a scrollable widget that displays a list of Fibonacci numbers with an associated icon. The application includes tap functionality that allows users to interact with numbers, filter them, and move items between the main list and a bottom sheet.

## Features

### 1. Scrollable Widget
- The main widget contains a vertically scrollable list.
- Initially, it loads the first **40 Fibonacci numbers**.
- Implements **lazy loading**, adding 10 more numbers when reaching the bottom.

### 2. Display Widget
- Each item in the list displays:
  - The **Fibonacci number**.
  - A **symbol (icon)** that represents its type.
  - The **original index** of the number.
- The icons are determined by:
  - Circle (🔵) if `number % 3 == 0`
  - Cross (❌) if `number % 3 == 1`
  - Square (⬜) if `number % 3 == 2`

### 3. Tap Functionality
- **On tapping a number**:
  - The number is **removed** from the main list and added to a bottom sheet.
  - The bottom sheet **only displays numbers of the same type** as the tapped number.
- **On tapping an item in the bottom sheet**:
  - The number is **removed from the bottom sheet** and **returned to its original position** in the main list.
  - The main list **highlights the returned item** and automatically scrolls to it.
- **Bottom Sheet Behavior**:
  - When opened, it scrolls to the highlighted item (if present).

### 4. Lazy Loading (Bonus Feature)
- When scrolling to the bottom, the app **loads 10 additional numbers** after a 1-second delay, showing a loading indicator.
- This ensures an infinite scroll experience.

## Implementation Details
### State Management
- **Stateful Widget** is used to handle the dynamic list updates.
- The `ListView.builder` efficiently renders only visible items.
- A **ScrollController** detects when the user reaches the bottom to trigger lazy loading.

### Code Breakdown
#### Fibonacci Number Generation
- The Fibonacci sequence is generated dynamically based on the required count.

#### Tap Handling
- **Main list tap:** Moves the item to the bottom sheet.
- **Bottom sheet tap:** Returns the item to the main list and highlights it.

#### Scroll Behavior
- The app automatically scrolls to the highlighted item when an item is re-added.

## Tech Stack
- **Flutter** (No third-party packages used)
- **Dart** for logic implementation

## How to Run
1. Clone this repository.
2. Open the project in your Flutter development environment.
3. Run the app using:
   ```sh
   flutter run
   ```

## Screenshots
<p align="center">
  <img src="assets/demo.gif" alt="animated"/>

</p>


## Conclusion
This project demonstrates **Flutter UI development, state management, and user interaction handling**. The implementation avoids third-party libraries, showcasing pure **Flutter capabilities**. The app provides an interactive and user-friendly experience with smooth scrolling, animations, and efficient list handling.

