import 'package:dio/dio.dart';
import 'package:client/utils/token_manager.dart';

class ApiService {
  final Dio _dio;

  ApiService._() : _dio = Dio() {
    _dio.options.baseUrl = 'http://10.0.2.2:8000/api';
    
    _dio.options.headers = {
      'Accept': 'application/json',
      'Connection': 'keep-alive', 
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Tidak perlu lagi mengatur 'Accept' di sini karena sudah ada di options.headers
          return handler.next(options);
        },
      ),
    );
  }

  static final ApiService _instance = ApiService._();
  static ApiService get instance => _instance;

  // Metode untuk setiap endpoint API
  Future<Response> login(String email, String password) =>
      _dio.post('/auth/login', data: {'email': email, 'password': password});
      
  Future<Response> register(Map<String, dynamic> data) =>
      _dio.post('/auth/register', data: data);

  Future<Response> logout() => _dio.post('/auth/logout');

  Future<Response> getUserProfile() => _dio.get('/auth/user-profile');
  
  Future<Response> getUkms() => _dio.get('/ukm');

  Future<Response> getUkmDetail(int ukmId) => _dio.get('/ukm/$ukmId');

  Future<Response> getKegiatans({
    String? search,
    String? kategori,
    String? tanggal, 
  }) {
    final params = {
      'search': search,
      'kategori': kategori,
      'tanggal': tanggal,
    };

    params.removeWhere((key, value) => value == null || value.isEmpty);

    return _dio.get('/kegiatan', queryParameters: params);
  }

  Future<Response> daftarUkm(int ukmId) => _dio.post('/ukm/$ukmId/daftar');

  Future<Response> createUkm(Map<String, dynamic> ukmData, String? logoPath) async {
    final formData = FormData.fromMap(ukmData);

    if (logoPath != null) {
      formData.files.add(MapEntry(
        'logo', 
        await MultipartFile.fromFile(logoPath),
      ));
    }

    return _dio.post('/ukm', data: formData);
  }

  Future<Response> deleteUkm(int ukmId) => _dio.delete('/ukm/$ukmId');

  Future<Response> getMyUkms() => _dio.get('/my-ukm');

  Future<Response> getUpcomingEvents() => _dio.get('/dashboard/upcoming-events');

  Future<Response> submitUkmProposal(Map<String, String> data, String logoPath) async {
    final formData = FormData.fromMap(data);
    formData.files.add(MapEntry(
      'logo',
      await MultipartFile.fromFile(logoPath),
    ));
    return _dio.post('/proposal/ukm', data: formData);
  }

  Future<Response> getPendingProposals() => _dio.get('/proposal/ukm');

  Future<Response> approveProposal(int proposalId) => _dio.post('/proposal/ukm/$proposalId/approve');

  Future<Response> rejectProposal(int proposalId, String reason) => _dio.post('/proposal/ukm/$proposalId/reject', data: {'reason': reason});

  Future<Response> getKegiatanDetail(int kegiatanId) => _dio.get('/kegiatan/$kegiatanId');
  
  Future<Response> getManagedUkm() => _dio.get('/manage/ukm');
  
  Future<Response> toggleUkmRegistration() => _dio.post('/manage/ukm/toggle-registration');

  Future<Response> approveMember(int membershipId) => _dio.post('/manage/ukm/approve/$membershipId');

  Future<Response> removeMember(int membershipId) => _dio.delete('/manage/ukm/remove/$membershipId');

  Future<Response> updateProfile(Map<String, String> data, String? filePath) async {
    final formData = FormData.fromMap(data);
    if (filePath != null) {
      formData.files.add(MapEntry(
        'foto_profil',
        await MultipartFile.fromFile(filePath),
      ));
    }
    formData.fields.add(const MapEntry('_method', 'POST'));
    return _dio.post('/user/profile', data: formData);
  }

  Future<Response> getManagedKegiatan() => _dio.get('/manage/kegiatan');
  Future<Response> createKegiatan(FormData data) => _dio.post('/manage/kegiatan', data: data);
  Future<Response> updateKegiatan(int id, FormData data) => _dio.post('/manage/kegiatan/$id', data: data);
  Future<Response> deleteKegiatan(int id) => _dio.delete('/manage/kegiatan/$id');
}