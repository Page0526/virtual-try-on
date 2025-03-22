import React, { createContext, useState, useContext, ReactNode, useEffect } from 'react';

// Type definition for cart items
export type CartItem = {
  id: string;
  name: string;
  price: number;
  size: string;
  color: string;
  quantity: number;
  image: string;
  inBundle: boolean;
};

// Unique identifier for cart items
export type CartItemKey = {
  id: string;
  size: string;
  color: string;
};

// Define context type
type CartContextType = {
  cartItems: CartItem[];
  addToCart: (item: CartItem) => void;
  removeFromCart: (itemKey: CartItemKey) => void;
  updateQuantity: (itemKey: CartItemKey, increment: boolean) => void;
  getCartCount: () => number;
  clearCart: () => void;
};

// Create context with default values
const CartContext = createContext<CartContextType>({
  cartItems: [],
  addToCart: () => {},
  removeFromCart: () => {},
  updateQuantity: () => {},
  getCartCount: () => 0,
  clearCart: () => {},
});

// Helper function to check if two cart items are the same (same product, size, and color)
const isSameItem = (item1: CartItem, item2: CartItemKey): boolean => {
  return item1.id === item2.id && item1.size === item2.size && item1.color === item2.color;
};

// Create provider component
export const CartProvider: React.FC<{children: ReactNode}> = ({ children }) => {
  const [cartItems, setCartItems] = useState<CartItem[]>([]);
  
  // Debug: Log cart items whenever they change
  useEffect(() => {
    console.log('Cart updated, items count:', cartItems.length);
    if (cartItems.length > 0) {
      console.log('Cart items:', JSON.stringify(cartItems, null, 2));
    }
  }, [cartItems]);

  const addToCart = (newItem: CartItem) => {
    console.log('Adding to cart:', JSON.stringify(newItem, null, 2));
    
    setCartItems(prevItems => {
      // Check if product already exists with same size and color
      const existingItemIndex = prevItems.findIndex(item => 
        isSameItem(item, {id: newItem.id, size: newItem.size, color: newItem.color})
      );
      
      if (existingItemIndex >= 0) {
        // Update quantity if item already exists
        console.log('Item exists, updating quantity');
        const updatedItems = [...prevItems];
        updatedItems[existingItemIndex].quantity += newItem.quantity;
        return updatedItems;
      } else {
        // Add new item
        console.log('Adding new item to cart');
        return [...prevItems, newItem];
      }
    });
  };

  const removeFromCart = (itemKey: CartItemKey) => {
    console.log('Removing from cart:', JSON.stringify(itemKey, null, 2));
    setCartItems(prevItems => 
      prevItems.filter(item => !isSameItem(item, itemKey))
    );
  };

  const updateQuantity = (itemKey: CartItemKey, increment: boolean) => {
    console.log('Updating quantity for item:', JSON.stringify(itemKey, null, 2), 'increment:', increment);
    setCartItems(prevItems => 
      prevItems.map(item => {
        if (isSameItem(item, itemKey)) {
          return {
            ...item,
            quantity: increment ? item.quantity + 1 : Math.max(1, item.quantity - 1)
          };
        }
        return item;
      })
    );
  };

  const getCartCount = () => {
    const count = cartItems.reduce((sum, item) => sum + item.quantity, 0);
    return count;
  };

  const clearCart = () => {
    console.log('Clearing cart');
    setCartItems([]);
  };

  return (
    <CartContext.Provider value={{ 
      cartItems, 
      addToCart, 
      removeFromCart, 
      updateQuantity,
      getCartCount,
      clearCart 
    }}>
      {children}
    </CartContext.Provider>
  );
};

// Create a custom hook for easy context access
export const useCart = () => useContext(CartContext);

export default CartContext;