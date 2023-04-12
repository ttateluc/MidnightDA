# Licensed under the CC BY-NC 4.0 license (https://creativecommons.org/licenses/by-nc/4.0/)
# Experiment parameters.
synthetic_configurations="trainval_dark_CycleGANfc_DarkZurichTwilight"
real_configurations="day_refinenet"
initialization_configurations="original"
relative_weight_synthetic="1"
training_epochs="10"

# Test dataset.
imdb_test="Dark_Zurich_twilight"

# Testing script.
./test_mixed.sh ${synthetic_configurations} ${real_configurations} ${initialization_configurations} ${relative_weight_synthetic} ${training_epochs} ${imdb_test}



