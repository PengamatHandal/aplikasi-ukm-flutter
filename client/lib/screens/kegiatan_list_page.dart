// lib/screens/kegiatan_list_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/models/kegiatan.dart';
import 'package:client/screens/kegiatan_detail_page.dart';
import 'package:client/services/api_service.dart';

class KegiatanListPage extends StatefulWidget {
  const KegiatanListPage({super.key});

  @override
  State<KegiatanListPage> createState() => _KegiatanListPageState();
}

class _KegiatanListPageState extends State<KegiatanListPage> {
  late Future<List<Kegiatan>> _kegiatanFuture;

  final _searchController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _kegiatanFuture = _fetchKegiatan();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Kegiatan>> _fetchKegiatan() {
    return ApiService.instance.getKegiatans(
      search: _searchController.text,
      kategori: _selectedCategory,
      tanggal: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
    ).then((response) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Kegiatan.fromJson(json)).toList();
    }).catchError((error) {
      print("Error fetching kegiatan: $error");
      throw Exception('Gagal memuat kegiatan');
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _kegiatanFuture = _fetchKegiatan();
    });
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedDate = null;
    });
    _refreshData();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && mounted) {
      setState(() => _selectedDate = pickedDate);
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Kegiatan>>(
        future: _kegiatanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Gagal memuat data.\nCoba lagi nanti.\n\nError: ${snapshot.error}', textAlign: TextAlign.center),
                ),
              );
          }
          
          final kegiatans = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: CustomScrollView(
              slivers: [
                _buildSliverHeader(context),
                SliverPersistentHeader(
                  delegate: _SliverHeaderDelegate(
                    child: _buildSearchAndFilter(),
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'Info Terbaru',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (kegiatans.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('Tidak ada kegiatan ditemukan.'))
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final kegiatan = kegiatans[index];
                          return Card(
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.1),
                            margin: const EdgeInsets.only(bottom: 20.0),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => KegiatanDetailPage(kegiatanId: kegiatan.id),
                                ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (kegiatan.gambarUrl != null)
                                    Image.network(
                                      kegiatan.gambarUrl!,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 120,
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      child: Center(child: Icon(Icons.event, color: Theme.of(context).primaryColor, size: 40)),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kegiatan.judul,
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text(kegiatan.ukm?.namaUkm ?? 'UKM', style: const TextStyle(fontSize: 12)),
                                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('d MMM yyyy', 'id_ID').format(kegiatan.tanggalAcara),
                                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: kegiatans.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160.0,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 2,
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/logo-unpam.png', height: 60),
              const SizedBox(height: 16),
              Text(
                'Unit Kegiatan Mahasiswa',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Universitas Pamulang',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama kegiatan...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onSubmitted: (value) => _refreshData(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 18),
                  label: Text(_selectedDate == null ? 'Pilih Tanggal' : DateFormat('d MMM').format(_selectedDate!)),
                  onPressed: _selectDate,
                ),
                if (_selectedCategory != null || _selectedDate != null || _searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ActionChip(
                      avatar: const Icon(Icons.clear, size: 18),
                      label: const Text('Reset'),
                      onPressed: _resetFilters,
                      backgroundColor: Colors.red.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  // ignore: unused_element_parameter
  _SliverHeaderDelegate({required this.child, this.height = 130.0});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return true;
  }
}