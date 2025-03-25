import { Colors } from '@/constants/Colors';
import React from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, SafeAreaView, StatusBar, Platform } from 'react-native';
import { useCart } from '../cart/cartContext';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';

interface CartItemProps {
  item: {
    id: number;
    name: string;
    price: number;
    quantity: number;
    itemlink: string;
  };
  onRemove: (id: number) => void;
  onDecrement: (id: number) => void;
  onIncrement: (id: number) => void;
}

interface GroupedItemProps {
  title: string;
  items: CartItemProps['item'][];
  onRemove: (id: number) => void;
  onDecrement: (id: number) => void;
  onIncrement: (id: number) => void;
}

const CartItem: React.FC<CartItemProps> = ({ item, onRemove, onDecrement, onIncrement }) => {
  return (
    <View className="flex-row bg-white rounded-xl p-4 mb-3">
      <Image 
        source={{ uri: item.itemlink }} 
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
            className="w-6 h-6 items-center justify-center rounded"
            style={{backgroundColor: Colors.PRIMARY}}
          >
            <Text className="text-white font-bold">-</Text>
          </TouchableOpacity>
          
          <Text className="mx-2 text-sm min-w-6 text-center">{item.quantity}</Text>
          
          <TouchableOpacity 
            onPress={() => onIncrement(item.id)}
            className="w-6 h-6 items-center justify-center rounded"
            style={{backgroundColor: Colors.PRIMARY}}
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
  const router = useRouter();
  // Use the cart context instead of local state
  const { cartItems, removeFromCart, incrementQuantity, decrementQuantity, calculateTotal } = useCart();

  // Group the first two items (if they exist)
  const groupedItems = cartItems.slice(0, Math.min(2, cartItems.length));
  const regularItems = cartItems.slice(Math.min(2, cartItems.length));

  return (
    <SafeAreaView className="flex-1 bg-gray-100" style={{ backgroundColor: 'white' }}>
      <View className="flex-row items-center justify-between px-4 py-3 bg-white shadow-sm border-b border-gray-200">
        <TouchableOpacity 
          onPress={() => router.back()}
          className="p-1" 
        >
          <Ionicons name="arrow-back" size={24} color="#e14e69" />
        </TouchableOpacity>
        <Text className="text-center text-lg font-bold text-gray-800 flex-1">CART</Text>
        <View className="w-8"></View>
      </View>

      {cartItems.length === 0 ? (
        <View className="flex-1 justify-center items-center">
          <Text className="text-gray-500 text-lg">Your cart is empty</Text>
          <Text className="text-gray-400 text-sm mt-2">Add some items to get started</Text>
        </View>
      ) : (
        <>
          <ScrollView className="flex-1 px-4 pt-4" contentContainerStyle={{ paddingBottom: 100 }}>
            {groupedItems.length > 0 && (
              <GroupedItem 
                title="Together cheaper" 
                items={groupedItems} 
                onRemove={removeFromCart}
                onDecrement={decrementQuantity}
                onIncrement={incrementQuantity}
              />
            )}

            {regularItems.map(item => (
              <CartItem 
                key={item.id} 
                item={item} 
                onRemove={removeFromCart}
                onDecrement={decrementQuantity}
                onIncrement={incrementQuantity}
              />
            ))}

            {/* Responsive spacing - will be larger on bigger screens */}
            <View className="h-4 md:h-8 lg:h-12" />
          </ScrollView>
          
          {/* Fixed Footer with Total and Checkout Button */}
          <View className="absolute bottom-0 left-0 right-0 bg-white px-4 py-4 shadow-lg border-t border-gray-200">
            <View className="flex-row justify-between items-center mb-3">
              <Text className="text-gray-500 text-base">Total</Text>
              <Text className="text-xl font-bold">${calculateTotal().toFixed(2)}</Text>
            </View>

            <TouchableOpacity 
              className="w-full py-3 rounded-full"
              activeOpacity={0.8}
              style={{backgroundColor: Colors.PRIMARY}}
            >
              <Text className="text-white font-bold text-center text-lg">Go to Checkout</Text>
            </TouchableOpacity>
          </View>
        </>
      )}
    </SafeAreaView>
  );
}

export default CartScreen;