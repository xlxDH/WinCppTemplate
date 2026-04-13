#include <iostream>
using namespace std;

int main() {
  int T;
  cin >> T;
  while (T--) {
    int n;
    cin >> n;
    long long a = 1, b = 1;
    for (int i = 3; i <= n; i++) {
      long long c = a + b;
      a = b, b = c;
    }
    cout << (b % 7 == 0 || n % 2 == 0 && b % 2 == 0 ? "YES\n" : "NO\n");
  }
  return 0;
}


