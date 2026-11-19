// Two original iterations per main-loop iteration, then a remainder loop.
let n = 7;
let i = 0;
let total = 0;
while (i + 1 < n) {
    total = total + i * i;
    total = total + (i + 1) * (i + 1);
    i = i + 2;
}
while (i < n) {
    total = total + i * i;
    i = i + 1;
}
print(total);
