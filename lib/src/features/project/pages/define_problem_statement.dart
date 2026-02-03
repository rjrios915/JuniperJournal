import 'package:flutter/material.dart';
import 'package:juniper_journal/src/features/project/project.dart';
import 'package:juniper_journal/src/shared/styling/theme.dart';
import 'package:juniper_journal/src/shared/widgets/widgets.dart';
import '../../../backend/db/repositories/projects_repo.dart';

class DefineProblemStatementScreen extends StatefulWidget {
  final String projectId;
  final String projectName;
  final List<String> tags;

  const DefineProblemStatementScreen({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.tags,
  });

  @override
  State<DefineProblemStatementScreen> createState() => _DefineProblemStatementScreenState();
}

class _DefineProblemStatementScreenState extends State<DefineProblemStatementScreen> {
  final _problemController = TextEditingController();
  final _projectsRepo = ProjectsRepo();
  bool _isLoading = false;

  // TODO: should eventually be extracted to a constants file or stored in db if dynamic
  final List<String> difficultyLevels = ["Basic", "Intermediate", "Advanced"];
  final List<String> subjectDomains = [
    "Environment & Sustainability",
    "Engineering & Design",
    "Energy & Systems",
    "Community & The Built Environment",
  ];

  String? _selectedDifficulty;
  String? _selectedDomain;

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.border),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Problem Statement", 
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE5E5EA), width: 0.6)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.projectName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            _buildTagWrap(),

            const SizedBox(height: 8),
            _buildSectionTitle("Write Problem Statement"),
            const SizedBox(height: 12),
            _buildProblemInput(),

            const SizedBox(height: 32),
            _buildSectionTitle("Subject Domain"),
            _buildDropdown(subjectDomains, _selectedDomain, (val) => setState(() => _selectedDomain = val)),

            const SizedBox(height: 32),
            _buildSectionTitle("Difficulty Level"),
            _buildDropdown(difficultyLevels, _selectedDifficulty, (val) => setState(() => _selectedDifficulty = val)),

            const SizedBox(height: 40),
            
            SubmitButton(
              label: "Create",
              isLoading: _isLoading,
              backgroundColor: AppColors.primary,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }

  // UI Helper Methods

  Widget _buildTagWrap() {
    return Wrap(
      spacing: 8,
      children: widget.tags.map((tag) => Chip(
        label: Text(tag, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFDCF7E4),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      )).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _buildProblemInput() {
    return TextFormField(
      controller: _problemController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Describe the challenge your project aims to address...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        // decoration: AppColors.standardInputDecoration,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Logic Helper

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    final success = await _projectsRepo.updateProblemStatement(
      id: widget.projectId,
      problemStatement: _problemController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProjectDashboard(
          projectId: widget.projectId, 
          projectName: widget.projectName, 
          tags: widget.tags
        )),
        (route) => route.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save. Please try again.')),
      );
    }
  }
}