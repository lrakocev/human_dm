function vals = create_random_grid(size_of_grid, want_order,order_dir)

vals = rand(size_of_grid^2,1);

if want_order
    reshaped = reshape(vals, size_of_grid, []);
    sorted = sort(reshaped,2,order_dir);
    vals = reshape(sorted, size_of_grid^2, []);
end

end