import React, { createContext, useContext, useState, ReactNode } from 'react';

interface FittingState {
  garmentUri: string | null;
  modelUri: string | null;
  resultUri: string | null;
  setGarmentUri: (uri: string | null) => void;
  setModelUri: (uri: string | null) => void;
  setResultUri: (uri: string | null) => void;
  reset: () => void;
}

const FittingContext = createContext<FittingState | undefined>(undefined);

export const FittingProvider = ({ children }: { children: ReactNode }) => {
  const [garmentUri, setGarmentUri] = useState<string | null>(null);
  const [modelUri, setModelUri] = useState<string | null>(null);
  const [resultUri, setResultUri] = useState<string | null>(null);

  const reset = () => {
    setGarmentUri(null);
    setModelUri(null);
    setResultUri(null);
  };

  return (
    <FittingContext.Provider
      value={{ garmentUri, modelUri, resultUri, setGarmentUri, setModelUri, setResultUri, reset }}
    >
      {children}
    </FittingContext.Provider>
  );
};

export const useFittingContext = () => {
  const context = useContext(FittingContext);
  if (!context) throw new Error('useFittingContext must be used within a FittingProvider');
  return context;
};