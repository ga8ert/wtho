import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../l10n/app_localizations.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileBloc()..add(EditProfileLoadRequested()),
      child: const _EditProfileBody(),
    );
  }
}

class _EditProfileBody extends StatelessWidget {
  const _EditProfileBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.success) {
          Navigator.of(context).pop(true);
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<EditProfileBloc>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              AppLocalizations.of(context)!.edit_profile_title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: state.loading
                    ? null
                    : () => bloc.add(EditProfileSubmitted()),
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tabs (Edit/Preview)
                      Text(
                        AppLocalizations.of(context)!.media,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PhotoGrid(state: state, bloc: bloc),
                      const SizedBox(height: 24),
                      _ProfileField(
                        label: AppLocalizations.of(context)!.name,
                        initialValue: state.name,
                        onChanged: (v) =>
                            bloc.add(EditProfileFieldChanged('name', v)),
                      ),
                      _ProfileField(
                        label: AppLocalizations.of(context)!.surname,
                        initialValue: state.surname,
                        onChanged: (v) =>
                            bloc.add(EditProfileFieldChanged('surname', v)),
                      ),
                      _ProfileField(
                        label: AppLocalizations.of(context)!.nickname,
                        initialValue: state.nickname,
                        onChanged: (v) =>
                            bloc.add(EditProfileFieldChanged('nickname', v)),
                      ),
                      _ProfileField(
                        label: AppLocalizations.of(context)!.email,
                        initialValue: state.email,
                        onChanged: (v) =>
                            bloc.add(EditProfileFieldChanged('email', v)),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _ProfileField(
                        label: AppLocalizations.of(context)!.age,
                        initialValue: state.age > 0 ? state.age.toString() : '',
                        onChanged: (v) => bloc.add(
                          EditProfileFieldChanged('age', int.tryParse(v) ?? 0),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.about_me,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        minLines: 3,
                        maxLines: 6,
                        controller: TextEditingController(text: state.about),
                        onChanged: (v) =>
                            bloc.add(EditProfileFieldChanged('about', v)),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.about_me_hint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _PhotoGrid extends StatefulWidget {
  final EditProfileState state;
  final EditProfileBloc bloc;
  const _PhotoGrid({required this.state, required this.bloc});

  @override
  State<_PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<_PhotoGrid> {
  bool isPicking = false;

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, i) {
        if (i < widget.state.photoUrls.length) {
          final url = widget.state.photoUrls[i];
          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: url.startsWith('http')
                      ? Image.network(url, fit: BoxFit.cover)
                      : Image.file(File(url), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => widget.bloc.add(EditProfilePhotoRemoved(i)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close, color: Colors.red, size: 22),
                  ),
                ),
              ),
            ],
          );
        } else {
          return GestureDetector(
            onTap: () async {
              if (isPicking) return;
              setState(() => isPicking = true);
              try {
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (picked != null) {
                  widget.bloc.add(EditProfilePhotoAdded(picked.path));
                }
              } finally {
                if (mounted) setState(() => isPicking = false);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!, width: 1),
              ),
              child: const Center(
                child: Icon(Icons.add_a_photo, color: Colors.grey, size: 32),
              ),
            ),
          );
        }
      },
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  const _ProfileField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // Використовувати controller лише для ініціалізації, а не при кожному build
    final controller = TextEditingController.fromValue(
      TextEditingValue(
        text: initialValue,
        selection: TextSelection.collapsed(offset: initialValue.length),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
