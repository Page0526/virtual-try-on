import React, { useState } from 'react';
import { View, Text, Image, TouchableOpacity, Modal, SafeAreaView, StatusBar, StyleSheet } from 'react-native';
import { AntDesign, Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useCart, CartItem, CartItemKey } from './cartContext';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';

const CartScreen: React.FC = () => {
  const router = useRouter();
  const { cartItems, updateQuantity, removeFromCart } = useCart();
  const [selectedQuantityItem, setSelectedQuantityItem] = useState<CartItemKey | null>(null);
  const [quantityModalVisible, setQuantityModalVisible] = useState<boolean>(false);

  const handleGoBack = (): void => {
    router.back();
  };

  // Calculate total price
  const totalPrice: number = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);

  const continueShopping = (): void => {
    router.push('/home');
  };

  const handleQuantitySelect = (item: CartItem): void => {
    setSelectedQuantityItem({
      id: item.id,
      size: item.size,
      color: item.color
    });
    setQuantityModalVisible(true);
  };

  const handleSetQuantity = (quantity: number): void => {
    if (selectedQuantityItem) {
      const item = cartItems.find(item => 
        item.id === selectedQuantityItem.id && 
        item.size === selectedQuantityItem.size && 
        item.color === selectedQuantityItem.color
      );
      
      if (item) {
        const diff = quantity - item.quantity;
        for (let i = 0; i < Math.abs(diff); i++) {
          updateQuantity(selectedQuantityItem, diff > 0);
        }
      }
    }
    setQuantityModalVisible(false);
    setSelectedQuantityItem(null);
  };

  const handleRemoveItem = (item: CartItem): void => {
    removeFromCart({
      id: item.id,
      size: item.size,
      color: item.color
    });
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />

      {/* Main container with fixed header, scrollable content and fixed footer */}
      <View style={styles.mainContainer}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.headerTitle}>GIỎ HÀNG</Text>
          <TouchableOpacity 
            onPress={handleGoBack}
            style={styles.closeButton}
          >
            <AntDesign name="close" size={24} color="black" />
          </TouchableOpacity>
        </View>

        {/* Scrollable Content */}
        <KeyboardAwareScrollView 
          style={styles.scrollContent}
          contentContainerStyle={cartItems.length === 0 ? styles.emptyCartContainer : undefined}
        >
          {/* Empty Cart Message */}
          {cartItems.length === 0 ? (
            <View style={styles.emptyCartContent}>
              <Ionicons name="cart-outline" size={80} color="#ddd" />
              <Text style={styles.emptyCartText}>Giỏ hàng trống</Text>
              <TouchableOpacity 
                style={styles.continueShoppingButton}
                onPress={continueShopping}
              >
                <Text style={styles.continueShoppingText}>Tiếp tục mua sắm</Text>
              </TouchableOpacity>
            </View>
          ) : (
            // Cart Items
            cartItems.map((item: CartItem, index: number) => (
              <View 
                key={`${item.id}-${item.size}-${item.color}-${index}`}
                style={styles.cartItemContainer}
              >
                <View style={styles.itemContent}>
                  {/* Row with product image and details */}
                  <View style={styles.productRow}>
                    {/* Product Image */}
                    <Image 
                      source={{ uri: item.image }}
                      style={styles.productImage}
                      resizeMode="cover"
                    />
                    
                    {/* Product Details */}
                    <View style={styles.productDetails}>
                      <View style={styles.itemHeader}>
                        <Text style={styles.itemName}>{item.name}</Text>
                        <TouchableOpacity onPress={() => handleRemoveItem(item)}>
                          <AntDesign name="close" size={20} color="black" />
                        </TouchableOpacity>
                      </View>
                      
                      <Text style={styles.itemDetail}>
                        Màu sắc: {item.color === 'gray' ? '07 GRAY' : 
                                  item.color === 'black' ? '09 BLACK' : 
                                  item.color.toUpperCase()}
                      </Text>
                      <Text style={styles.itemDetail}>
                        Kích cỡ: {item.size.includes('CM') ? `Nam ${item.size}` : item.size}
                      </Text>
                      <Text style={styles.itemPrice}>
                        {item.price.toLocaleString('vi-VN')} VND
                      </Text>
                    </View>
                  </View>
                  
                  {/* Quantity and Subtotal Section */}
                  <View style={styles.quantityAndTotal}>
                    <View style={styles.quantityRow}>
                      <TouchableOpacity 
                        style={styles.quantitySelector}
                        onPress={() => handleQuantitySelect(item)}
                      >
                        <Text style={styles.quantityText}>{item.quantity}</Text>
                        <AntDesign name="down" size={12} color="black" />
                      </TouchableOpacity>
                    </View>
                    
                    <View style={styles.subtotalContainer}>
                      <Text style={styles.subtotalLabel}>TỔNG:</Text>
                      <Text style={styles.subtotalValue}>
                        {(item.price * item.quantity).toLocaleString('vi-VN')} VND
                      </Text>
                    </View>
                  </View>
                </View>
              </View>
            ))
          )}
          
          {/* Extra space at bottom to ensure content isn't covered by footer */}
          <View style={styles.bottomSpacing} />
        </KeyboardAwareScrollView>

        {/* Footer with Total and Checkout button */}
        {cartItems.length > 0 && (
          <View style={styles.footer}>
            <View style={styles.totalContainer}>
              <Text style={styles.totalLabel}>TỔNG CỘNG</Text>
              <Text style={styles.totalValue}>
                {totalPrice.toLocaleString('vi-VN')} VND
              </Text>
            </View>
            
            <TouchableOpacity 
              style={styles.checkoutButton}
              onPress={() => console.log('Checkout')}
            >
              <Text style={styles.checkoutButtonText}>
                THANH TOÁN
              </Text>
            </TouchableOpacity>
          </View>
        )}
      </View>

      {/* Quantity Modal */}
      <Modal
        animationType="fade"
        transparent={true}
        visible={quantityModalVisible}
        onRequestClose={() => setQuantityModalVisible(false)}
      >
        <TouchableOpacity 
          style={styles.modalOverlay}
          activeOpacity={1}
          onPress={() => setQuantityModalVisible(false)}
        >
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Chọn số lượng</Text>
            <View style={styles.quantityGrid}>
              {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((num: number) => (
                <TouchableOpacity
                  key={num}
                  style={styles.quantityOption}
                  onPress={() => handleSetQuantity(num)}
                >
                  <Text style={styles.quantityOptionText}>{num}</Text>
                </TouchableOpacity>
              ))}
            </View>
          </View>
        </TouchableOpacity>
      </Modal>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  mainContainer: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
  },
  header: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#e5e5e5',
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'center',
    position: 'relative',
  },
  headerTitle: {
    fontSize: 22,
    fontWeight: 'bold',
  },
  closeButton: {
    position: 'absolute',
    right: 16,
  },
  scrollContent: {
    flex: 1,
  },
  emptyCartContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  emptyCartContent: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 40,
  },
  emptyCartText: {
    fontSize: 18,
    color: '#666',
    marginTop: 16,
  },
  continueShoppingButton: {
    backgroundColor: 'black',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 24,
    marginTop: 24,
  },
  continueShoppingText: {
    color: 'white',
    fontWeight: 'bold',
  },
  cartItemContainer: {
    borderBottomWidth: 1,
    borderBottomColor: '#eeeeee',
  },
  itemContent: {
    padding: 16,
  },
  productRow: {
    flexDirection: 'row',
    marginBottom: 12,
  },
  productImage: {
    width: 80,
    height: 100,
    borderRadius: 4,
    backgroundColor: '#f5f5f5',
    marginRight: 12,
  },
  productDetails: {
    flex: 1,
  },
  itemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 6,
  },
  itemName: {
    fontSize: 18,
    fontWeight: '500',
    flex: 1,
    paddingRight: 8,
  },
  itemDetail: {
    fontSize: 16,
    color: '#555',
    marginTop: 4,
  },
  itemPrice: {
    fontSize: 16,
    fontWeight: 'bold',
    marginTop: 8,
  },
  quantityAndTotal: {
    marginTop: 10,
  },
  quantityRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  quantitySelector: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ddd',
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: 4,
  },
  quantityText: {
    fontSize: 16,
    marginRight: 8,
  },
  subtotalContainer: {
    marginTop: 8,
  },
  subtotalLabel: {
    color: '#888',
    fontSize: 14,
  },
  subtotalValue: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  bottomSpacing: {
    height: 120,
  },
  footer: {
    borderTopWidth: 1,
    borderTopColor: '#e5e5e5',
    backgroundColor: 'white',
  },
  totalContainer: {
    padding: 16,
  },
  totalLabel: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  totalValue: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  checkoutButton: {
    backgroundColor: '#FF0000',
    padding: 16,
    alignItems: 'center',
  },
  checkoutButtonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContent: {
    backgroundColor: 'white',
    borderRadius: 8,
    padding: 16,
    width: '80%',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
    textAlign: 'center',
  },
  quantityGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  quantityOption: {
    width: '30%',
    padding: 12,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 4,
    marginBottom: 8,
    alignItems: 'center',
  },
  quantityOptionText: {
    fontSize: 16,
  },
});

export default CartScreen;