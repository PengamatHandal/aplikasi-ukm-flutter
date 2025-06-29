// lib/screens/proposal_review_page.dart
import 'package:flutter/material.dart';
import 'package:client/models/ukm_proposal.dart';
import 'package:client/services/api_service.dart';

class ProposalReviewPage extends StatefulWidget {
  const ProposalReviewPage({super.key});

  @override
  State<ProposalReviewPage> createState() => _ProposalReviewPageState();
}

class _ProposalReviewPageState extends State<ProposalReviewPage> {
  late Future<List<UkmProposal>> _proposalsFuture;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  void _loadProposals() {
    setState(() {
      _proposalsFuture = ApiService.instance.getPendingProposals().then((response) {
        final List<dynamic> data = response.data;
        return data.map((json) => UkmProposal.fromJson(json)).toList();
      });
    });
  }

  Future<void> _approve(int proposalId) async {
    await ApiService.instance.approveProposal(proposalId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proposal disetujui!'), backgroundColor: Colors.green));
    _loadProposals(); 
  }

  Future<void> _reject(int proposalId) async {
    String reason = '';
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Tolak Proposal"),
      content: TextField(
        onChanged: (value) => reason = value,
        decoration: InputDecoration(hintText: "Alasan penolakan..."),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
        FilledButton(onPressed: () async {
           if (reason.isNotEmpty) {
             await ApiService.instance.rejectProposal(proposalId, reason);
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proposal ditolak.'), backgroundColor: Colors.orange));
             Navigator.pop(context);
             _loadProposals(); 
           }
        }, child: Text("Tolak"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Proposal UKM')),
      body: FutureBuilder<List<UkmProposal>>(
        future: _proposalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada proposal yang perlu direview.'));
          }
          final proposals = snapshot.data!;
          return ListView.builder(
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proposal.namaUkm, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Kategori: ${proposal.kategori}'),
                      const SizedBox(height: 4),
                      Text('Diajukan oleh: ${proposal.proposer.name} (${proposal.proposer.nim})'),
                      const Divider(height: 20),
                      Text(proposal.deskripsi),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () => _reject(proposal.id), child: const Text('Tolak')),
                          const SizedBox(width: 8),
                          FilledButton(onPressed: () => _approve(proposal.id), child: const Text('Setujui')),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}