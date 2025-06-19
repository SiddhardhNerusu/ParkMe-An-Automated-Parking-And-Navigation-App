import SwiftUI

struct PaymentHistoryView: View {
    @ObservedObject var manager = PaymentManager.shared

    private func formattedDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .short
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }

    var body: some View {
        List {
            if manager.payments.isEmpty {
                Text("No payments recorded yet.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(manager.payments.reversed()) { payment in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("📍 \(payment.locationName)")
                            .font(.headline)

                        Text("Start: \(formattedDate(payment.startTime))")
                        Text("End: \(formattedDate(payment.endTime))")
                        Text("Duration: \(payment.duration) min")
                        Text("Amount Paid: £\(String(format: "%.2f", payment.totalCost))")
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Payment History")
    }
}
