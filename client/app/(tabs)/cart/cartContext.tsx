import React, { createContext, useContext, useState, ReactNode } from 'react';

// Define CartItem interface
export interface CartItemType {
  id: number;
  name: string;
  price: number;
  quantity: number;
  itemlink: string;
}

// Define the context interface
interface CartContextType {
  cartItems: CartItemType[];
  addToCart: (item: CartItemType) => void;
  removeFromCart: (id: number) => void;
  incrementQuantity: (id: number) => void;
  decrementQuantity: (id: number) => void;
  calculateTotal: () => number;
}

// Create the context
const CartContext = createContext<CartContextType | undefined>(undefined);

// Create provider component
export const CartProvider = ({ children }: { children: ReactNode }) => {
  // Initial cart items
  const [cartItems, setCartItems] = useState<CartItemType[]>([
    { id: 1, name: 'Casual T-shirt', price: 399.00, quantity: 1, itemlink: 'https://harpersbazaarprod.vtexassets.com/unsafe/768x0/center/middle/filters:quality(80)/https%3A%2F%2Fharpersbazaarprod.vtexassets.com%2Farquivos%2Fids%2F849903%2Fimage_1.jpg%3Fv%3D638775684080800000' },
    { id: 2, name: 'Daniella Shevel', price: 695.00, quantity: 1, itemlink: 'https://harpersbazaarprod.vtexassets.com/unsafe/768x0/center/middle/filters:quality(80)/https%3A%2F%2Fharpersbazaarprod.vtexassets.com%2Farquivos%2Fids%2F422427%2Fimage_1.jpg%3Fv%3D638594046348100000' },
  ]);

  // Add item to cart - handles both adding new items and updating quantity of existing items
  const addToCart = (item: CartItemType) => {
    setCartItems(prevItems => {
      // Check if item already exists in cart
      const existingItem = prevItems.find(cartItem => cartItem.id === item.id);
      
      if (existingItem) {
        // If item exists, update quantity
        return prevItems.map(cartItem => 
          cartItem.id === item.id 
            ? { ...cartItem, quantity: cartItem.quantity + 1 } 
            : cartItem
        );
      } else {
        // If item doesn't exist, add it to cart
        return [...prevItems, item];
      }
    });
  };

  // Remove item from cart
  const removeFromCart = (id: number) => {
    setCartItems(prevItems => prevItems.filter(item => item.id !== id));
  };

  // Increment item quantity
  const incrementQuantity = (id: number) => {
    setCartItems(prevItems => 
      prevItems.map(item => 
        item.id === id ? { ...item, quantity: item.quantity + 1 } : item
      )
    );
  };

  // Decrement item quantity
  const decrementQuantity = (id: number) => {
    setCartItems(prevItems => 
      prevItems.map(item => 
        item.id === id && item.quantity > 1 
          ? { ...item, quantity: item.quantity - 1 } 
          : item
      )
    );
  };

  // Calculate total cart price
  const calculateTotal = (): number => {
    return cartItems.reduce((total, item) => total + (item.price * item.quantity), 0);
  };

  // Context value
  const value = {
    cartItems,
    addToCart,
    removeFromCart,
    incrementQuantity,
    decrementQuantity,
    calculateTotal
  };

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
};

// Create hook for using the cart context
export const useCart = () => {
  const context = useContext(CartContext);
  if (context === undefined) {
    throw new Error('useCart must be used within a CartProvider');
  }
  return context;
};