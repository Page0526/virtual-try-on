import React, { useState } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, SafeAreaView, StatusBar } from 'react-native';

interface CartItemType {
  id: number;
  name: string;
  price: number;
  quantity: number;
}

interface CartItemProps {
  item: CartItemType;
  onRemove: (id: number) => void;
  onDecrement: (id: number) => void;
  onIncrement: (id: number) => void;
}

interface GroupedItemProps {
  title: string;
  items: CartItemType[];
  onRemove: (id: number) => void;
  onDecrement: (id: number) => void;
  onIncrement: (id: number) => void;
}

const CartItem: React.FC<CartItemProps> = ({ item, onRemove, onDecrement, onIncrement }) => {
  return (
    <View className="flex-row bg-white rounded-xl p-4 mb-3">
      <Image 
        source={require('@/assets/images/background.png')} 
        className="w-20 h-20 rounded-lg" 
      />
      
      <View className="flex-1 ml-3">
        <Text className="text-sm font-medium">
          {item.name}
        </Text>
        <View className="flex-row items-center mt-1">
          <Text className="text-xs">Size L • Color: </Text>
          <Text className="text-xs text-blue-500">Blue</Text>
        </View>
        <Text className="font-semibold mt-1">${item.price.toFixed(2)}</Text>
      </View>

      <View className="justify-between items-end">
        <TouchableOpacity onPress={() => onRemove(item.id)} className="p-1">
          <View className="w-6 h-6 items-center justify-center rounded-full bg-gray-100">
            <Text className="text-gray-500">×</Text>
          </View>
        </TouchableOpacity>

        <View className="flex-row items-center">
          <TouchableOpacity 
            onPress={() => onDecrement(item.id)}
            className="w-6 h-6 items-center justify-center bg-red-500 rounded"
          >
            <Text className="text-white font-bold">-</Text>
          </TouchableOpacity>
          
          <Text className="mx-2 text-sm min-w-6 text-center">{item.quantity}</Text>
          
          <TouchableOpacity 
            onPress={() => onIncrement(item.id)}
            className="w-6 h-6 items-center justify-center bg-red-500 rounded"
          >
            <Text className="text-white font-bold">+</Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
};

const GroupedItem: React.FC<GroupedItemProps> = ({ title, items, onRemove, onDecrement, onIncrement }) => {
  return (
    <View className="mb-5">
      <View className="flex-row justify-between items-center mb-3">
        <Text className="font-semibold">{title}</Text>
        <TouchableOpacity>
          <View className="w-6 h-6 items-center justify-center rounded-full bg-gray-100">
            <Text className="text-gray-500">×</Text>
          </View>
        </TouchableOpacity>
      </View>
      
      {items.map(item => (
        <CartItem 
          key={item.id} 
          item={item} 
          onRemove={onRemove}
          onDecrement={onDecrement}
          onIncrement={onIncrement}
        />
      ))}
    </View>
  );
};

const CartScreen: React.FC = () => {
  const [cartItems, setCartItems] = useState<CartItemType[]>([
    { id: 1, name: 'Popular shoes best choice from Adidas', price: 39.00, quantity: 1 },
    { id: 2, name: 'Popular shoes best choice from Adidas', price: 39.00, quantity: 1 },
    { id: 3, name: 'Popular shoes best choice from Adidas', price: 39.00, quantity: 1 },
    { id: 4, name: 'Popular shoes best choice from Adidas', price: 39.00, quantity: 1 },
  ]);

  const handleRemoveItem = (id: number): void => {
    setCartItems(cartItems.filter(item => item.id !== id));
  };

  const handleIncrement = (id: number): void => {
    setCartItems(cartItems.map(item => 
      item.id === id ? { ...item, quantity: item.quantity + 1 } : item
    ));
  };

  const handleDecrement = (id: number): void => {
    setCartItems(cartItems.map(item => 
      item.id === id && item.quantity > 1 ? { ...item, quantity: item.quantity - 1 } : item
    ));
  };

  const calculateTotal = (): number => {
    return cartItems.reduce((total, item) => total + (item.price * item.quantity), 0);
  };

  // Group the first two items
  const groupedItems = cartItems.slice(0, 2);
  const regularItems = cartItems.slice(2);

  return (
    <SafeAreaView className="flex-1 bg-gray-100">
      <StatusBar barStyle="dark-content" />
      
      <View className="px-4 py-3 bg-white shadow-md">
        <Text className="text-center text-lg font-bold text-gray-800">CART</Text>
      </View>

      <ScrollView className="flex-1 px-4 pt-4">
        <GroupedItem 
          title="Together cheaper" 
          items={groupedItems} 
          onRemove={handleRemoveItem}
          onDecrement={handleDecrement}
          onIncrement={handleIncrement}
        />

        {regularItems.map(item => (
          <CartItem 
            key={item.id} 
            item={item} 
            onRemove={handleRemoveItem}
            onDecrement={handleDecrement}
            onIncrement={handleIncrement}
          />
        ))}

        {/* Responsive spacing - will be larger on bigger screens */}
        <View className="h-4 md:h-8 lg:h-12" />

        <View className="bg-white p-4 shadow-lg mt-4">
          <View className="flex-row justify-between items-center mb-4">
            <Text className="text-gray-500">Total</Text>
            <Text className="text-xl font-bold">${calculateTotal().toFixed(2)}</Text>
          </View>

            <TouchableOpacity 
            className="w-full bg-red-500 py-3 rounded-full"
            activeOpacity={0.8}
            >
            <Text className="text-white font-bold text-center text-lg">Go to Checkout</Text>
            </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

export default CartScreen;