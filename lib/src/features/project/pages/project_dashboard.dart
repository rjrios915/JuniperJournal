import 'package:flutter/material.dart';
import 'package:juniper_journal/src/features/project/project.dart';
import 'package:juniper_journal/src/shared/styling/theme.dart';

class ProjectDashboard extends StatelessWidget {
  final String projectId;
  final String projectName;
  final List<String> tags;

  const ProjectDashboard({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.border),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(projectName, 
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE5E5EA), width: 0.6)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Manage Project", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    "Timeline",
                    Icons.timeline,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => InteractiveTimelinePage(projectId: projectId, projectName: projectName, tags: tags))),
                  ),
                  _buildMenuCard(
                    context,
                    "Materials & Cost",
                    Icons.attach_money,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => MaterialsCostPage(projectId: projectId, projectName: projectName, tags: tags))),
                  ),
                  _buildMenuCard(
                    context,
                    "Journal Log",
                    Icons.book,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => JournalLogScreen(projectId: projectId, projectName: projectName, tags: tags))),
                  ),
                  _buildMenuCard(
                    context,
                    "Impact",
                    Icons.speed,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => MetricsPage(projectId: projectId, projectName: projectName, tags: tags))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}