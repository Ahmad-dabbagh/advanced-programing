#include <bits/stdc++.h>
using namespace std;

static inline long long parseMoneyToCents(const string& s) {
    size_t i = 0, n = s.size();
    while (i < n && isspace((unsigned char)s[i])) i++;
    while (n > i && isspace((unsigned char)s[n-1])) n--;
    if (i >= n) return LLONG_MIN;

    bool neg = false;
    if (s[i] == '+' || s[i] == '-') { neg = (s[i] == '-'); i++; }

    long long dollars = 0;
    while (i < n && isdigit((unsigned char)s[i])) {
        dollars = dollars * 10 + (s[i] - '0');
        i++;
    }

    long long cents = 0;
    int d1 = 0, d2 = 0, d3 = 0;
    if (i < n && s[i] == '.') {
        i++;
        if (i < n && isdigit((unsigned char)s[i])) { d1 = s[i]-'0'; i++; }
        if (i < n && isdigit((unsigned char)s[i])) { d2 = s[i]-'0'; i++; }
        if (i < n && isdigit((unsigned char)s[i])) { d3 = s[i]-'0'; i++; }
    }

    cents = d1 * 10 + d2;
    if (d3 >= 5) cents += 1;
    if (cents >= 100) { dollars += 1; cents -= 100; }

    long long total = dollars * 100 + cents;
    return neg ? -total : total;
}

static inline string centsToMoney(long long c) {
    long long sign = (c < 0) ? -1 : 1;
    c = llabs(c);
    long long d = c / 100;
    long long r = c % 100;
    ostringstream oss;
    if (sign < 0) oss << "-";
    oss << d << "." << setw(2) << setfill('0') << r;
    return oss.str();
}

int main(int argc, char** argv) {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    string inPath = (argc >= 2) ? argv[1] : "test_1m.csv";
    string outPath = "deductions_33_percent.txt";

    const long long FEE_NUM = 33;
    const long long FEE_DEN = 100;

    ifstream fin(inPath);
    if (!fin) {
        cerr << "ERROR: cannot open input file: " << inPath << "\n";
        return 1;
    }

    string line;
    if (!getline(fin, line)) {
        cerr << "ERROR: empty input\n";
        return 1;
    }

    vector<long long> base;   base.reserve(1000000);
    vector<int> rem;          rem.reserve(1000000);
    vector<char> bonus;       bonus.reserve(1000000);

    long long totalRevenueCents = 0;
    long long baseSum = 0;
    long long nProcessed = 0;

    vector<vector<int>> buckets(100);
    for (auto &b : buckets) b.reserve(10000);

    while (getline(fin, line)) {
        size_t pos = line.rfind(',');
        if (pos == string::npos) continue;
        string salaryStr = line.substr(pos + 1);

        while (!salaryStr.empty() && isspace((unsigned char)salaryStr.back())) salaryStr.pop_back();
        size_t i = 0; while (i < salaryStr.size() && isspace((unsigned char)salaryStr[i])) i++;
        salaryStr = salaryStr.substr(i);

        if (salaryStr.empty()) continue;

        long long salaryCents = parseMoneyToCents(salaryStr);
        if (salaryCents == LLONG_MIN) continue;

        totalRevenueCents += salaryCents;

        long long num = salaryCents * FEE_NUM;
        long long bded = num / FEE_DEN;
        int r = (int)(num % FEE_DEN);

        base.push_back(bded);
        rem.push_back(r);
        bonus.push_back(0);

        baseSum += bded;
        buckets[r].push_back((int)nProcessed);
        nProcessed++;
    }

    long long expectedCents = (totalRevenueCents * FEE_NUM + (FEE_DEN/2)) / FEE_DEN;
    long long diff = expectedCents - baseSum;

    if (diff > 0) {
        long long need = diff;
        for (int r = 99; r >= 0 && need > 0; --r) {
            auto &idxs = buckets[r];
            long long take = min<long long>(need, (long long)idxs.size());
            for (long long k = 0; k < take; ++k) bonus[idxs[(size_t)k]] = 1;
            need -= take;
        }
    } else if (diff < 0) {
        long long need = -diff;
        for (int r = 0; r <= 99 && need > 0; ++r) {
            auto &idxs = buckets[r];
            long long take = min<long long>(need, (long long)idxs.size());
            for (long long k = 0; k < take; ++k) bonus[idxs[(size_t)k]] = 1;
            need -= take;
        }
    }

    ofstream fout(outPath);
    if (!fout) {
        cerr << "ERROR: cannot open output file: " << outPath << "\n";
        return 1;
    }

    long long sumDeductionsCents = 0;
    for (long long idx = 0; idx < nProcessed; ++idx) {
        long long d = base[(size_t)idx];
        if (bonus[(size_t)idx]) d += (diff > 0 ? 1 : -1);
        sumDeductionsCents += d;
        fout << centsToMoney(d) << "\n";
    }

    long long discrepancyCents = llabs(sumDeductionsCents - expectedCents);
    string status = (discrepancyCents <= 1) ? "RECONCILED" : "DISCREPANCY";

    cout << "=== RECONCILIATION REPORT ===\n";
    cout << "Contractors processed: " << nProcessed << "\n";
    cout << "Total revenue: " << centsToMoney(totalRevenueCents) << "\n";
    cout << "Sum of deductions: " << centsToMoney(sumDeductionsCents) << "\n";
    cout << "Expected (33% of total): " << centsToMoney(expectedCents) << "\n";
    cout << "Discrepancy: " << centsToMoney(discrepancyCents) << "\n";
    cout << "Status: " << status << "\n";
    cout << "=============================\n";

    return 0;
}
