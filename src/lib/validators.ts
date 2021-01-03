export interface EventListenersInterface {
  open: Array<Function>;
  message: Array<Function>;
  error: Array<Function>;
  close: Array<Function>;
  [key: string]: Array<Function>;
}

export interface StorageParams {
  storageType: string;
  storageKey: string;
  storageValue: string;
}
