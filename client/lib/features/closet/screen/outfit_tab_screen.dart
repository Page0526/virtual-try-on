// lib/features/closet/screen/outfit_tab_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/controller/outfit_bloc.dart';
import 'package:myapp/features/closet/controller/outfit_event.dart';
import 'package:myapp/features/closet/controller/outfit_state.dart';
import 'package:myapp/features/closet/model/outfit.dart';

class OutfitTabScreen extends StatefulWidget {
  const OutfitTabScreen({super.key});

  @override
  State<OutfitTabScreen> createState() => _OutfitTabScreenState();
}

class _OutfitTabScreenState extends State<OutfitTabScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _outfitNameController = TextEditingController();
  String _selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    if (context.read<OutfitBloc>().state is! OutfitCategoriesLoaded) {
      context.read<OutfitBloc>().add(LoadOutfitCategories());
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _outfitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OutfitBloc, OutfitState>(
      listener: (context, state) {
        if (state is OutfitCategoriesLoaded) {
          if (_selectedCategoryId.isNotEmpty) {
            context.read<OutfitBloc>().add(LoadOutfitsByCategory(_selectedCategoryId));
          }
        }
      },
      builder: (context, state) {
        if (state is OutfitLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OutfitCategoriesLoaded) {
          final categories = state.categories;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: categories.any((category) => category.id == _selectedCategoryId)
                            ? _selectedCategoryId
                            : categories.isNotEmpty
                                ? categories.first.id
                                : null,
                        hint: const Text('Chọn danh mục'),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                            context.read<OutfitBloc>().add(LoadOutfitsByCategory(value));
                          }
                        },
                        isExpanded: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddCategoryDialog(context),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<OutfitBloc, OutfitState>(
                    builder: (context, outfitState) {
                      if (outfitState is OutfitsByCategoryLoaded) {
                        final outfits = outfitState.outfits;
                        return ListView.builder(
                          itemCount: outfits.length + 1,
                          itemBuilder: (context, index) {
                            if (index == outfits.length) {
                              return _buildCreateOutfit(context);
                            }
                            final outfit = outfits[index];
                            return _buildOutfitItem(outfit, context);
                          },
                        );
                      } else if (outfitState is OutfitError) {
                        return Center(child: Text('Error: ${outfitState.message}'));
                      }
                      return const Center(child: Text('Chưa có outfit nào'));
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is OutfitError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildOutfitItem(Outfit outfit, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          context.go('/closet/outfit/${outfit.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: outfit.imageUrl != null && File(outfit.imageUrl!).existsSync()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(outfit.imageUrl!),
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(height: 8.0),
              Text(
                outfit.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${outfit.items.length} items',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      // TODO: Thêm logic chỉnh sửa Outfit
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOutfit(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          _outfitNameController.clear();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tạo Outfit Mới'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _outfitNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên Outfit',
                        hintText: 'Nhập tên Outfit',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButton<String>(
                      value: _selectedCategoryId,
                      hint: const Text('Chọn danh mục'),
                      items: (context.read<OutfitBloc>().state as OutfitCategoriesLoaded)
                          .categories
                          .map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () {
                      final name = _outfitNameController.text.trim();
                      if (name.isNotEmpty && _selectedCategoryId.isNotEmpty) {
                        final newOutfit = Outfit(
                          id: DateTime.now().toString(),
                          name: name,
                          categoryId: _selectedCategoryId,
                        );
                        context.read<OutfitBloc>().add(AddOutfit(newOutfit));
                        Navigator.pop(context);
                        context.read<OutfitBloc>().add(LoadOutfitsByCategory(_selectedCategoryId));
                      }
                    },
                    child: const Text('Tạo'),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.grey),
              SizedBox(width: 8.0),
              Text('Create an outfit', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    _categoryController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Danh Mục Mới'),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Tên danh mục',
              hintText: 'Nhập tên danh mục',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final name = _categoryController.text.trim();
                if (name.isNotEmpty) {
                  // TODO: Thêm logic để thêm danh mục mới vào OutfitService
                  Navigator.pop(context);
                }
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );
  }
}