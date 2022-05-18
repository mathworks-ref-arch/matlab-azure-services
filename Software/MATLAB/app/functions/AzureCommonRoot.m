function [str] = AzureCommonRoot(varargin)
% AZURECOMMONROOT Helper function to locate the Azure Common location
% Locate the installation of the Azure interface package to allow easier construction
% of absolute paths to the required dependencies.

% Copyright 2020-2021 The MathWorks, Inc.

% TODO Remove and replace with just one common root

str = fileparts(fileparts(fileparts(mfilename('fullpath'))));

end %function
