import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../api/network/supabase_client_provider.dart';
import '../../api/support/support_models.dart';
import '../../errors/app_error.dart';

final supportServiceProvider = Provider(
  (ref) => SupportService(ref.read(supabaseClientProvider)),
);

class SupportService {
  final SupabaseClient _supabase;

  SupportService(this._supabase);

  String get generateSupportId => const Uuid().v4();

  Future<String> addSupportCase(AddSupportCaseRequest supportCase) async {
    try {
      final id = supportCase.id.isNotEmpty ? supportCase.id : generateSupportId;
      await _supabase.from('contact_support').insert({
        'id': id,
        'user_id': supportCase.user_id,
        'title': supportCase.title,
        'description': supportCase.description,
        'attachment_urls': supportCase.attachment_urls,
      });
      return id;
    } catch (error, stack) {
      throw AppError.fromError(error, stack);
    }
  }
}
