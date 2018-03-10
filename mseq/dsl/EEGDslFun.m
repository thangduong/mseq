function err = eegdslfun(dipole, data)

[m t err] = eeggetdipoletrace(data, dipole(1:3), dipole(4:6));